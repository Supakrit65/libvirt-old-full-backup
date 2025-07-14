#!/usr/bin/env bash
#
# vm_backup.sh – KVM backup (disk + XML) via virsh external snapshots,
#                handling all disk devices (Type=disk) and skipping CD-ROMs,
#                dumping and patching XML after backup,
#                with optional internal QCOW2 compression,
#                and "restore" + date suffix on <name> and filename,
#                including migration of internal snapshots with explicit disk path replacement
#
# Usage: vm_backup.sh --backup-base-dir DIR --vm-domain NAME [--max-backups N] [--compress]

set -euo pipefail

# Default values
MAX_BACKUPS=6
COMPRESS=false
NEW_VM_NAME=""

usage() {
  cat <<EOF
Usage: $(basename "$0") --backup-base-dir DIR --vm-domain NAME [--max-backups N] [--compress]
Options:
  --backup-base-dir DIR    Base directory in which to store backups
  --vm-domain NAME         Name of the libvirt VM to back up
  --max-backups N          Number of backups to keep (default: \$MAX_BACKUPS)
  --compress               Enable internal QCOW2 compression (default: off)
  -h, --help               Show this help message
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --backup-base-dir) BACKUP_BASE="$2"; shift 2 ;;
    --vm-domain)       VM="$2";          shift 2 ;;
    --max-backups)     MAX_BACKUPS="$2"; shift 2 ;;
    --compress)        COMPRESS=true;    shift    ;;
    -h|--help)         usage; exit 0              ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

# Validate required args
[[ -n "${BACKUP_BASE:-}" && -n "${VM:-}" ]] || { echo "ERROR: --backup-base-dir and --vm-domain are required" >&2; usage; exit 1; }

# Setup Variables
TIMESTAMP=$(date +%F-%H%M%S)
DEST="$BACKUP_BASE/$VM/$TIMESTAMP"
RESTORED_NAME="${VM}-restore-${TIMESTAMP}"
INTERNAL_SNAPSHOTS=$(virsh snapshot-list "$VM" --name 2>/dev/null | grep -v "^$" || true)
NEW_UUID=$(uuidgen)
mkdir -p "$DEST"
echo "[$(date '+%F %T')] Starting backup of VM '$VM' → $DEST (compress=$COMPRESS)"

# 1) Enumerate all "disk" devices (skip iso / cdrom)
mapfile -t DISK_TARGETS < <(virsh domblklist "$VM" --details | awk '$1=="file" && $2=="disk" { print $3 }')
mapfile -t DISK_SRCS < <(virsh domblklist "$VM" --details | awk '$1=="file" && $2=="disk" { print $4 }')
if (( ${#DISK_TARGETS[@]} == 0 )); then
  echo "ERROR: No disk devices found for VM '$VM'" >&2
  exit 1
fi
# Print all detected disks
echo "Detected disk devices for VM '$VM':"
for i in "${!DISK_TARGETS[@]}"; do
  echo "  ${DISK_TARGETS[i]} → ${DISK_SRCS[i]}"
done

# 2) If VM is running, do external snapshot; otherwise, skip to copy
STATE=$(virsh domstate "$VM" 2>/dev/null || echo "not-found")
SNAP_NAME="backup-$TIMESTAMP"
OVERLAY_PATHS=()
if [[ "$STATE" == "running" ]]; then
  echo "  VM is running; creating external snapshot overlays…"
  SNAP_ARGS=()
  for dev in "${DISK_TARGETS[@]}"; do
    OVERLAY_PATH="$DEST/${dev}.snap.qcow2"
    SNAP_ARGS+=(--diskspec "$dev,file=$OVERLAY_PATH")
    OVERLAY_PATHS+=("$OVERLAY_PATH")
  done
  virsh snapshot-create-as --domain "$VM" --name "$SNAP_NAME" --disk-only --atomic "${SNAP_ARGS[@]}"
else
  echo "  VM not running (state=$STATE); skipping snapshot"
fi

# 3) Copy each frozen base disk to backup folder (optionally compress)
echo "  Copying disks:"
for i in "${!DISK_TARGETS[@]}"; do
  dev=${DISK_TARGETS[i]}
  src=${DISK_SRCS[i]}
  dst="$DEST/${dev}.qcow2"
  echo "    $dev: $src → $dst"
  cp --sparse=always "$src" "$dst"
  if [[ "$COMPRESS" == true ]]; then
    echo "    ↳ compressing $dev …"
    qemu-img convert -O qcow2 -c "$dst" "${dst}.tmp"
    mv "${dst}.tmp" "$dst"
  fi
done

# 4) Handle internal snapshots (migrate + patch + inject uuid)
if [[ -n "$INTERNAL_SNAPSHOTS" ]]; then
  echo "  Internal snapshots found:\n$INTERNAL_SNAPSHOTS"
  mkdir -p "$DEST/snapshots"
  while IFS= read -r SNAPSHOT; do
    echo "    → Migrating snapshot: $SNAPSHOT"
    SNAPSHOT_XML="$DEST/snapshots/${SNAPSHOT}.xml"
    virsh snapshot-dumpxml "$VM" "$SNAPSHOT" > "$SNAPSHOT_XML"

    xmlstarlet ed -L \
      -u "/domainsnapshot/domain/name" -v "$RESTORED_NAME" \
      -u "/domainsnapshot/domain/uuid" -v "$NEW_UUID" \
      -u "/domainsnapshot/inactiveDomain/name" -v "$RESTORED_NAME" \
      -u "/domainsnapshot/inactiveDomain/uuid" -v "$NEW_UUID" \
      "$SNAPSHOT_XML"

    for i in "${!DISK_TARGETS[@]}"; do
      dev=${DISK_TARGETS[i]}
      old_path=${DISK_SRCS[i]}
      new_path="$DEST/${dev}.qcow2"
      echo "      ↳ Updating disk path for $dev: $old_path → $new_path"
      xmlstarlet ed -L \
        -u "/domainsnapshot/domain/devices/disk[source/@file='$old_path']/source/@file" -v "$new_path" \
        -u "/domainsnapshot/inactiveDomain/devices/disk[source/@file='$old_path']/source/@file" -v "$new_path" \
        "$SNAPSHOT_XML"
    done
  done <<< "$INTERNAL_SNAPSHOTS"
else
  echo "  No internal snapshots found."
fi

# 5) Merge overlays if needed
if [[ "$STATE" == "running" ]]; then
  echo "  Merging overlays back…"
  for dev in "${DISK_TARGETS[@]}"; do
    virsh blockcommit "$VM" "$dev" --active --pivot
  done
  echo "  Removing overlays…"
  rm -f "${OVERLAY_PATHS[@]}"
  echo "  Removing snapshot metadata…"
  virsh snapshot-delete "$VM" "$SNAP_NAME" --metadata
fi

# 6) Dump and patch VM XML
XML_FILE="$DEST/${RESTORED_NAME}.xml"
virsh dumpxml "$VM" > "$XML_FILE"
xmlstarlet ed -L \
  -u "/domain/name" -v "$RESTORED_NAME" \
  -u "/domain/uuid" -v "$NEW_UUID" \
  "$XML_FILE"
for i in "${!DISK_TARGETS[@]}"; do
  old_path=${DISK_SRCS[i]}
  new_path="$DEST/${DISK_TARGETS[i]}.qcow2"
  xmlstarlet ed -L \
    -u "/domain/devices/disk[source/@file='$old_path']/source/@file" -v "$new_path" \
    "$XML_FILE"
done

# 7) Cleanup old backups
(
  cd "$BACKUP_BASE/$VM"
  ls -1dt */ | tail -n +"$((MAX_BACKUPS+1))" | xargs -r rm -rf
)
echo "[$(date '+%F %T')] Backup complete → $DEST"
echo "   - Disks: ${DISK_TARGETS[*]}"
echo "   - XML:   $XML_FILE"
echo "   - UUID:  $NEW_UUID"
[[ -n "$INTERNAL_SNAPSHOTS" ]] && echo "   - Snapshots: $DEST/snapshots/"
echo "   - Kept latest $MAX_BACKUPS backups under $BACKUP_BASE/$VM/"
