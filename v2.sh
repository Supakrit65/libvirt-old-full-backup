#!/usr/bin/env bash
#
# vm_backup.sh – KVM backup (disk + XML) via virsh external snapshots,
#                handling all disk devices (Type=disk) and skipping CD-ROMs,
#                dumping and patching XML after backup,
#                with "restore" + date suffix on <name> and filename
#
# Usage: vm_backup.sh --backup-base-dir DIR --vm-domain NAME [--max-backups N]
#

set -euo pipefail

# Default values
MAX_BACKUPS=6

# Print usage
usage() {
  cat <<EOF
Usage: $(basename "$0") --backup-base-dir DIR --vm-domain NAME [--max-backups N]
Options:
  --backup-base-dir DIR    Base directory in which to store backups
  --vm-domain NAME         Name of the libvirt VM to back up
  --max-backups N          Number of backups to keep (default: $MAX_BACKUPS)
  -h, --help               Show this help message
EOF
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --backup-base-dir)
      BACKUP_BASE="$2"
      shift 2
      ;;
    --vm-domain)
      VM="$2"
      shift 2
      ;;
    --max-backups)
      MAX_BACKUPS="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

# Validate required args
if [[ -z "${BACKUP_BASE:-}" || -z "${VM:-}" ]]; then
  echo "ERROR: --backup-base-dir and --vm-domain are required" >&2
  usage
  exit 1
fi

TIMESTAMP=$(date +%F-%H%M%S)
DEST="$BACKUP_BASE/$VM/$TIMESTAMP"
mkdir -p "$DEST"
echo "[$(date '+%F %T')] Starting backup of VM '$VM' → $DEST"

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
OVERLAY_PATHS=()
if [[ "$STATE" == "running" ]]; then
  echo "  VM is running; creating external snapshot overlays…"
  SNAP_ARGS=()
  for dev in "${DISK_TARGETS[@]}"; do
    OVERLAY_PATH="$DEST/${dev}.snap.qcow2"
    SNAP_ARGS+=(--diskspec "$dev,file=$OVERLAY_PATH")
    OVERLAY_PATHS+=("$OVERLAY_PATH")
  done
  virsh snapshot-create-as \
    --domain "$VM" \
    --name "backup-$TIMESTAMP" \
    --disk-only --atomic --no-metadata \
    "${SNAP_ARGS[@]}"
else
  echo "  VM is not running (state='$STATE'); skipping snapshot"
fi

# 3) Copy each frozen base disk to backup folder
echo "  Copying & compressing disks:"
for i in "${!DISK_TARGETS[@]}"; do
  dev=${DISK_TARGETS[i]}
  src=${DISK_SRCS[i]}
  dst="$DEST/${dev}.qcow2"
  echo "    $dev: $src → $dst"
  
  # 3a) Copy sparingly
  cp --sparse=always "$src" "$dst"
  
  # 3b) Compress internally
  echo "    ↳ compressing $dev …"
  qemu-img convert -O qcow2 -c "$dst" "${dst}.tmp"
  mv "${dst}.tmp" "$dst"
done

# 4) If we took snapshots, merge them back into their bases and remove overlays
if [[ "$STATE" == "running" ]]; then
  echo "  Merging overlays back into base disks…"
  for dev in "${DISK_TARGETS[@]}"; do
    virsh blockcommit "$VM" "$dev" --active --pivot
  done
  for overlay in "${OVERLAY_PATHS[@]}"; do
    rm -f "$overlay"
  done
fi

# 5) Dump the VM’s XML
RESTORED_NAME="${VM}-restore-${TIMESTAMP}"
XML_FILE="$DEST/${RESTORED_NAME}.xml"
virsh dumpxml "$VM" > "$XML_FILE"

# 6) Patch the XML:
#    a) Remove any <uuid>…</uuid>
#    b) Rename <name>…</name> → <RESTORED_NAME>
#    c) Update each disk <source file='…'> to our backed-up qcow2
sed -i '/<uuid>.*<\/uuid>/d' "$XML_FILE"
sed -i "s|<name>.*</name>|<name>${RESTORED_NAME}</name>|" "$XML_FILE"
for i in "${!DISK_TARGETS[@]}"; do
  dev=${DISK_TARGETS[i]}
  src=${DISK_SRCS[i]}
  sed -i "s|file='$src'|file='$DEST/${dev}.qcow2'|g" "$XML_FILE"
done

echo "[$(date '+%F %T')] Backup complete: $DEST"
echo "   - Disks backed up: ${DISK_TARGETS[*]}"
echo "   - XML file:       $XML_FILE (VM name set to <${RESTORED_NAME}>)"

# 7) Rotate old backups, keeping only the $MAX_BACKUPS newest
(
  cd "$BACKUP_BASE/$VM"
  ls -1dt */ | tail -n +"$((MAX_BACKUPS+1))" | xargs -r rm -rf
)
echo "Retained latest $MAX_BACKUPS backups under $BACKUP_BASE/$VM/"
