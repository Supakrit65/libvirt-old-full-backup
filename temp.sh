#!/usr/bin/env bash
#
# vm_backup.sh – KVM backup (disks + XML) via virsh external snapshots
#
# * Handles every <disk type='file' device='disk'> (skips ISO / CD‑ROM)
# * Optional internal compression with --compress
# * Restored XML/Snapshots renamed to  "<vm>-restore-<timestamp>"  (or --new-vm-domain-name)
# * Guarantees snapshot metadata & overlay files are cleaned on error (trap‑based)
# * Rotates old backups, keeping the newest N (default 6)
#
# Usage:
#   vm_backup.sh --backup-base-dir DIR --vm-domain NAME \
#                [--max-backups N] [--compress] \
#                [--new-vm-domain-name NAME]

set -euo pipefail

##############################################################################
# 0. Defaults, helpers, argument parsing
##############################################################################
MAX_BACKUPS=6
COMPRESS=false
NEW_VM_NAME=""

log(){ printf '[%s] %s\n' "$(date '+%F %T')" "$*"; }
die(){ log "ERROR: $*" >&2; exit 1; }
need(){ command -v "$1" &>/dev/null || die "'$1' required but not found"; }

usage(){ cat <<EOF
Usage: $(basename "$0") --backup-base-dir DIR --vm-domain NAME [options]
  --backup-base-dir DIR       Where backups are stored
  --vm-domain NAME            libvirt domain to back up
  --max-backups N             How many backups to keep (default $MAX_BACKUPS)
  --compress                  Re‑compress qcow2 after copy
  --new-vm-domain-name NAME   Override restored domain name
  -h | --help                 Show this help message
EOF
}

# ---- parse args -----------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
    --backup-base-dir) BACKUP_BASE=$2; shift 2 ;;
    --vm-domain)       VM=$2;          shift 2 ;;
    --max-backups)     MAX_BACKUPS=$2; shift 2 ;;
    --compress)        COMPRESS=true;  shift   ;;
    --new-vm-domain-name) NEW_VM_NAME=$2; shift 2 ;;
    -h|--help)         usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

[[ -n ${BACKUP_BASE:-} && -n ${VM:-} ]] || { usage; exit 1; }
[[ $MAX_BACKUPS =~ ^[0-9]+$ ]] || die "--max-backups must be numeric"

for bin in virsh xmlstarlet; do need "$bin"; done
$COMPRESS && need qemu-img

##############################################################################
# 1. Variables & cleanup trap
##############################################################################
TIMESTAMP=$(date +%F-%H%M%S)
DEST="$BACKUP_BASE/$VM/$TIMESTAMP"
RESTORED_NAME="${NEW_VM_NAME:-${VM}-restore-$TIMESTAMP}"
NEW_UUID=$(uuidgen)

SNAP_NAME="backup-$TIMESTAMP"
SNAP_TAKEN=false       # becomes true immediately after snapshot‑create‑as
OVERLAYS_PIVOTED=false # becomes true after blockcommit --pivot
OVERLAY_PATHS=()

cleanup() {
  # If snapshot exists but overlays not pivoted, merge + remove safely
  if \$SNAP_TAKEN && ! \$OVERLAYS_PIVOTED; then
    log "cleanup: attempting blockcommit pivot for unfinished snapshot"
    for dev in "${DISK_TARGETS[@]:-}"; do
      virsh blockcommit "$VM" "$dev" --active --pivot &>/dev/null || true
    done
    log "cleanup: deleting snapshot metadata + orphan overlays"
    virsh snapshot-delete "$VM" "$SNAP_NAME" --metadata &>/dev/null || true
    rm -f "${OVERLAY_PATHS[@]:-}" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

mkdir -p "$DEST"
log "Backup started for '$VM' → $DEST  (compress=$COMPRESS)"

##############################################################################
# 2. Enumerate disks
##############################################################################
mapfile -t DISK_TARGETS < <(virsh domblklist "$VM" --details | awk '$1=="file"&&$2=="disk"{print $3}')
mapfile -t DISK_SRCS    < <(virsh domblklist "$VM" --details | awk '$1=="file"&&$2=="disk"{print $4}')
((${#DISK_TARGETS[@]})) || die "No disk devices for '$VM'"
log "Disks:"; for i in "${!DISK_TARGETS[@]}"; do echo "  • ${DISK_TARGETS[i]} → ${DISK_SRCS[i]}"; done

##############################################################################
# 3. Create external snapshot (running guests)
##############################################################################
STATE=$(virsh domstate "$VM" 2>/dev/null || echo unknown)
if [[ $STATE == running ]]; then
  log "Creating external snapshots"
  for dev in "${DISK_TARGETS[@]}"; do
    overlay="$DEST/${dev}.snap.qcow2"
    virsh snapshot-create-as --domain "$VM" --name "$SNAP_NAME" \
      --disk-only --atomic --diskspec "$dev,file=$overlay"
    OVERLAY_PATHS+=("$overlay")
  done
  SNAP_TAKEN=true
else
  log "Guest not running — skip snapshot"
fi

##############################################################################
# 4. Copy disks (optionally compress)
##############################################################################
log "Copying disks…"
for i in "${!DISK_TARGETS[@]}"; do
  dst="$DEST/${DISK_TARGETS[i]}.qcow2"
  cp --sparse=always "${DISK_SRCS[i]}" "$dst"
  if \$COMPRESS; then
    log "  compress ${DISK_TARGETS[i]}"
    tmp=$(mktemp --tmpdir "${DISK_TARGETS[i]}.XXXXXX.qcow2")
    qemu-img convert -O qcow2 -c "$dst" "$tmp" && mv "$tmp" "$dst"
  fi
done

##############################################################################
# 5. Internal snapshot migration
##############################################################################
SNAPS=$(virsh snapshot-list "$VM" --name | grep -v '^$' || true)
if [[ -n $SNAPS ]]; then
  log "Migrating internal snapshots"; mkdir -p "$DEST/snapshots"
  while read -r snap; do
    xml="$DEST/snapshots/$snap.xml"
    virsh snapshot-dumpxml "$VM" "$snap" >"$xml"
    xmlstarlet ed -L \
      -u '/domainsnapshot/domain/name'         -v "$RESTORED_NAME" \
      -u '/domainsnapshot/domain/uuid'         -v "$NEW_UUID"      \
      -u '/domainsnapshot/inactiveDomain/name' -v "$RESTORED_NAME" \
      -u '/domainsnapshot/inactiveDomain/uuid' -v "$NEW_UUID"      "$xml"
    for i in "${!DISK_TARGETS[@]}"; do
      old=${DISK_SRCS[i]} new="$DEST/${DISK_TARGETS[i]}.qcow2"
      xmlstarlet ed -L -u "/domainsnapshot//disk[source/@file='$old']/source/@file" -v "$new" "$xml"
    done
  done <<<"$SNAPS"
else
  log "No internal snapshots"
fi

##############################################################################
# 6. Merge/pivot overlays back (if running)
##############################################################################
if [[ $STATE == running ]]; then
  log "Pivot overlays back into base disks"
  for dev in "${DISK_TARGETS[@]}"; do
    virsh blockcommit "$VM" "$dev" --active --pivot
  done
  OVERLAYS_PIVOTED=true
  rm -f "${OVERLAY_PATHS[@]}"
  virsh snapshot-delete "$VM" "$SNAP_NAME" --metadata
fi

##############################################################################
# 7. Dump & patch domain XML
##############################################################################
XML="$DEST/$RESTORED_NAME.xml"
virsh dumpxml "$VM" >"$XML"
cmd=(xmlstarlet ed -L -u '/domain/name' -v "$RESTORED_NAME" -u '/domain/uuid' -v "$NEW_UUID")
for i in "${!DISK_TARGETS[@]}"; do
  cmd+=( -u "/domain/devices/disk[source/@file='${DISK_SRCS[i]}']/source/@file" -v "$DEST/${DISK_TARGETS[i]}.qcow2" )
done
"${cmd[@]}"

##############################################################################
# 8. Rotate old backups
##############################################################################
(
  cd "$BACKUP_BASE/$VM" && ls -1dt */ | tail -n +"$((MAX_BACKUPS+1))" | xargs -r rm -rf
)

log "Backup DONE → $DEST"; [[ -n $SNAPS ]] && echo "   • snapshots dir: $DEST/snapshots"; echo "   • uuid: $NEW_UUID"; echo "   • xml : $XML"
