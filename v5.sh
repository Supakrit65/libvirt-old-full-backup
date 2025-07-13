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
#

set -euo pipefail

# Default values
MAX_BACKUPS=6
COMPRESS=false

usage() {
  cat <<EOF
Usage: $(basename "$0") --backup-base-dir DIR --vm-domain NAME [--max-backups N] [--compress]
Options:
  --backup-base-dir DIR    Base directory in which to store backups
  --vm-domain NAME         Name of the libvirt VM to back up
  --max-backups N          Number of backups to keep (default: $MAX_BACKUPS)
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
    -h|--help)         usage; exit 0      ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

# Validate required args
[[ -n "${BACKUP_BASE:-}" && -n "${VM:-}" ]] || { echo "ERROR: --backup-base-dir and --vm-domain are required" >&2; usage; exit 1; }

TIMESTAMP=$(date +%F-%H%M%S)
DEST="$BACKUP_BASE/$VM/$TIMESTAMP"
mkdir -p "$DEST"
echo "[$(date '+%F %T')] Starting backup of VM '$VM' → $DEST (compress=$COMPRESS)"

# 1) Enumerate all "disk" devices (skip iso / cdrom)
mapfile -t DISK_TARGETS < <(
  virsh domblklist "$VM" --details \
    | awk '$1=="file" && $2=="disk" { print $3 }'
)
mapfile -t DISK_SRCS < <(
  virsh domblklist "$VM" --details \
    | awk '$1=="file" && $2=="disk" { print $4 }'
)
if (( ${#DISK_TARGETS[@]} == 0 )); then
  echo "ERROR: No disk devices found for VM '$VM'" >&2
  exit 1
fi

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
  # NB: omit --no-metadata so that snapshot metadata is preserved
  virsh snapshot-create-as \
    --domain "$VM" \
    --name "$SNAP_NAME" \
    --disk-only --atomic \
    "${SNAP_ARGS[@]}"
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
  else
    echo "    ↳ skipping compression for $dev"
  fi
done

# 4) Check for internal snapshots and migrate them
echo "  Checking for internal snapshots..."
INTERNAL_SNAPSHOTS=$(virsh snapshot-list "$VM" --name 2>/dev/null | grep -v "^$" || true)
if [[ -n "$INTERNAL_SNAPSHOTS" ]]; then
  echo "  Internal snapshots found: $INTERNAL_SNAPSHOTS"
  mkdir -p "$DEST/snapshots"
  while IFS= read -r snap; do
    echo "    Migrating snapshot '$snap'..."
    SNAP_XML="$DEST/snapshots/${snap}.xml"
    virsh snapshot-dumpxml "$VM" "$snap" > "$SNAP_XML"
    # Update snapshot XML to point to backed-up disk paths
    for i in "${!DISK_TARGETS[@]}"; do
      dev=${DISK_TARGETS[i]}
      src=${DISK_SRCS[i]}
      new_path="$DEST/${dev}.qcow2"
      echo "      Updating disk path in snapshot '$snap': $src → $new_path"
      sed -i "s|file='$src'|file='$new_path'|g" "$SNAP_XML"
      # Verify replacement
      if grep -q "file='$new_path'" "$SNAP_XML"; then
        echo "      ↳ Successfully updated path for $dev in $SNAP_XML"
      else
        echo "      ↳ WARNING: Failed to update path $src to $new_path in $SNAP_XML"
      fi
    done
    # Update snapshot XML name to include restore suffix
    sed -i "s|<name>.*</name>|<name>${snap}-restore-${TIMESTAMP}</name>|" "$SNAP_XML"
    # Remove UUID to avoid conflicts on restore
    sed -i '/<uuid>.*<\/uuid>/d' "$SNAP_XML"
  done <<< "$INTERNAL_SNAPSHOTS"
else
  echo "  No internal snapshots found."
fi

# 5) Merge overlays back into base and remove overlays + metadata
if [[ "$STATE" == "running" ]]; then
  echo "  Merging overlays back into base disks…"
  for dev in "${DISK_TARGETS[@]}"; do
    virsh blockcommit "$VM" "$dev" --active --pivot
  done

  echo "  Removing overlay files…"
  rm -f "${OVERLAY_PATHS[@]}"

  echo "  Deleting snapshot metadata…"
  virsh snapshot-delete "$VM" "$SNAP_NAME" --metadata
fi

# 6) Dump the VM’s XML
RESTORED_NAME="${VM}-restore-${TIMESTAMP}"
XML_FILE="$DEST/${RESTORED_NAME}.xml"
virsh dumpxml "$VM" > "$XML_FILE"

# 7) Patch the XML:
#    a) Remove any <uuid>…</uuid>
#    b) Rename <name>…</name> → <RESTORED_NAME>
#    c) Update each disk <source file='…'> to our backed-up qcow2
sed -i '/<uuid>.*<\/uuid>/d' "$XML_FILE"
sed -i "s|<name>.*</name>|<name>${RESTORED_NAME}</name>|" "$XML_FILE"
for i in "${!DISK_TARGETS[@]}"; do
  dev=${DISK_TARGETS[i]}
  src=${DISK_SRCS[i]}
  new_path="$DEST/${dev}.qcow2"
  sed -i "s|file='$src'|file='$new_path'|g" "$XML_FILE"
done

echo "[$(date '+%F %T')] Backup complete → $DEST"
echo "   - Disks backed up: ${DISK_TARGETS[*]}"
echo "   - XML file:       $XML_FILE (name set to <${RESTORED_NAME}>)"
if [[ -n "$INTERNAL_SNAPSHOTS" ]]; then
  echo "   - Snapshots backed up: $DEST/snapshots/"
fi

# 8) Rotate old backups, keeping only the $MAX_BACKUPS newest
(
  cd "$BACKUP_BASE/$VM"
  ls -1dt */ | tail -n +"$((MAX_BACKUPS+1))" | xargs -r rm -rf
)
echo "Kept $MAX_BACKUPS most recent backups under $BACKUP_BASE/$VM/"