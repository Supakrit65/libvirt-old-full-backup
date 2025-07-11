#!/usr/bin/env bash
#
# vm_backup.sh – KVM backup (disk + XML) via virsh,
#                live external snapshot if VM is running,
#                or simple copy if VM is shut off,
#                dumping and patching XML after backup,
#                with "restore" + date suffix on both <name> and filename
#
# Usage: vm_backup.sh <backup-base-dir> <vm-domain> [max-backups]
#

set -euo pipefail

BACKUP_BASE="$1"
VM="$2"
MAX_BACKUPS="${3:-6}"

if [[ -z "$BACKUP_BASE" || -z "$VM" ]]; then
  echo "Usage: $0 <backup-base-dir> <vm-domain> [max-backups]" >&2
  exit 1
fi

TIMESTAMP=$(date +%F-%H%M%S)
DEST="$BACKUP_BASE/$VM/$TIMESTAMP"
mkdir -p "$DEST"
echo "[$(date '+%F %T')] Starting backup of VM '$VM' → $DEST"

# Only single-disk vda supported
DISK_DEV="vda"
SRC_PATH=$(virsh domblklist "$VM" --details \
  | awk -v d="$DISK_DEV" '$3==d { print $4 }')
if [[ -z "$SRC_PATH" ]]; then
  echo "ERROR: Could not find disk '$DISK_DEV' for VM '$VM'" >&2
  exit 1
fi

# Determine VM state
STATE=$(virsh domstate "$VM" 2>/dev/null || echo "not-found")
case "$STATE" in
  running)
    echo "  VM is running; performing live external-snapshot backup"
    # 1a) Create external snapshot
    OVERLAY_PATH="$DEST/${DISK_DEV}.snap.qcow2"
    virsh snapshot-create-as \
      --domain "$VM" \
      --name "backup-$TIMESTAMP" \
      --disk-only --atomic --no-metadata \
      --diskspec "$DISK_DEV,file=$OVERLAY_PATH"
    # 1b) Copy frozen base
    cp "$SRC_PATH" "$DEST/${DISK_DEV}.qcow2"
    # 1c) Merge overlay back & clean
    virsh blockcommit "$VM" "$DISK_DEV" --active --pivot
    rm -f "$OVERLAY_PATH"
    ;;
  shut\ off|crashed|paused|shut\ down|shutdown)
    echo "  VM is not running ($STATE); performing offline copy backup"
    # Just copy the disk image
    cp "$SRC_PATH" "$DEST/${DISK_DEV}.qcow2"
    ;;
  *)
    echo "ERROR: VM state is '$STATE'; cannot backup" >&2
    exit 1
    ;;
esac

# 2) Dump the VM’s XML
RESTORED_NAME="${VM}-restore-${TIMESTAMP}"
XML_FILE="$DEST/${RESTORED_NAME}.xml"
virsh dumpxml "$VM" > "$XML_FILE"

# 3) Patch the XML:
#    a) Remove any existing <uuid>…</uuid>
#    b) Rename <name>…</name> → <RESTORED_NAME>
#    c) Point <source file='…'> at our backup qcow2
sed -i '/<uuid>.*<\/uuid>/d' "$XML_FILE"
sed -i "s|<name>.*</name>|<name>${RESTORED_NAME}</name>|" "$XML_FILE"
sed -i "s|file='$SRC_PATH'|file='$DEST/${DISK_DEV}.qcow2'|g" "$XML_FILE"

echo "[$(date '+%F %T')] Backup complete: $DEST"
echo "   - Disk:  $SRC_PATH → $DEST/${DISK_DEV}.qcow2"
echo "   - XML:   $XML_FILE (now <name>${RESTORED_NAME}</name>)"

# 4) Rotate old backups, keeping only the $MAX_BACKUPS newest
(
  cd "$BACKUP_BASE/$VM"
  ls -1dt */ | tail -n +"$((MAX_BACKUPS+1))" | xargs -r rm -rf
)
echo "Retained latest $MAX_BACKUPS backups under $BACKUP_BASE/$VM/"
