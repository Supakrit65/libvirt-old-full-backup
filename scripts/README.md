# `vm_backup.sh` - Step-by-Step KVM Backup Script Explanation

## Script Workflow: Step-by-Step

Below is a detailed breakdown of the steps `vm_backup.sh` executes to back up a VM:

### 1. Enumerate Disk Devices
- **What it does**: Identifies all disk devices (`<disk type='file' device='disk'>`) of the VM, excluding CD-ROMs or other non-disk devices.
- **How**: Uses `virsh domblklist --details` to list disk devices (e.g., `vda`, `vdb`) and their source paths (e.g., `/var/lib/libvirt/images/ubuntu20.qcow2`).
- **Output**: Logs each disk, e.g., `Detected disk devices for VM 'ubuntu20': vda → /var/lib/libvirt/images/ubuntu20.qcow2`.
- **Error handling**: Exits if no disk devices are found.

### 2. Create External Snapshot (if VM is Running)
- **What it does**: For a running VM, creates temporary overlay files to freeze base disks, allowing consistent copying while the VM continues running.
- **How**: 
  - Checks the VM state with `virsh domstate`.
  - If running, uses `virsh snapshot-create-as --disk-only --atomic` to create overlays (e.g., `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/vda.snap.qcow2`) for each disk.
  - Sets `SNAP_TAKEN=true` to track snapshot creation for cleanup.
- **If not running**: Skips this step and logs the VM state (e.g., `VM not running (state=shut off); skipping snapshot`).

### 3. Copy Disk Images
- **What it does**: Copies each base disk to the backup directory, optionally compressing them.
- **How**: 
  - Uses `cp --sparse=always` to copy disks (e.g., `/var/lib/libvirt/images/ubuntu20.qcow2` to `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/vda.qcow2`), preserving sparsity for efficiency.
  - If `--compress` is specified, uses `qemu-img convert -O qcow2 -c` to compress the copied disk, reducing size.
- **Output**: Logs each copy, e.g., `vda: /var/lib/libvirt/images/ubuntu20.qcow2 → /srv/backups/libvirt/ubuntu20/2025-07-14-172447/vda.qcow2`, and compression status if applicable.

### 4. Migrate Internal Snapshots
- **What it does**: Exports and updates any internal snapshots to ensure they can be restored with the backed-up disks.
- **How**: 
  - Checks for snapshots with `virsh snapshot-list --name`.
  - For each snapshot:
    - Exports the snapshot XML using `virsh snapshot-dumpxml` to `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/snapshots/<snapshot>.xml`.
    - Uses `xmlstarlet` to:
      - Update the VM name to `<vm>-restore-<timestamp>` or a custom `--new-vm-domain-name`.
      - Inject a new UUID to avoid conflicts.
      - Update disk paths (e.g., `/var/lib/libvirt/images/ubuntu20.qcow2` to `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/vda.qcow2`).
  - Logs each snapshot migration and path update, e.g., `Updating disk path for vda: /var/lib/libvirt/images/ubuntu20.qcow2 → /srv/backups/libvirt/ubuntu20/2025-07-14-172447/vda.qcow2`.
- **If no snapshots**: Logs `No internal snapshots found`.

### 5. Merge Overlays (if VM is Running)
- **What it does**: Merges temporary overlay files back into the base disks and cleans up.
- **How**: 
  - Uses `virsh blockcommit --active --pivot` to merge each overlay (e.g., `vda.snap.qcow2`) into the base disk.
  - Sets `OVERLAYS_PIVOTED=true` to indicate completion.
  - Deletes overlay files with `rm -f` and snapshot metadata with `virsh snapshot-delete --metadata`.
- **Output**: Logs actions, e.g., `Merging overlays back…`, `Removing overlays…`, `Removing snapshot metadata…`.

### 6. Dump and Patch VM XML
- **What it does**: Exports the VM’s XML configuration and updates it for restoration.
- **How**: 
  - Uses `virsh dumpxml` to save the XML to `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/<vm>-restore-<timestamp>.xml`.
  - Uses `xmlstarlet` to:
    - Set the VM name to `<vm>-restore-<timestamp>` or a custom `--new-vm-domain-name`.
    - Inject a new UUID.
    - Update disk paths to point to the backed-up disks.
- **Output**: Logs the XML file location, e.g., `XML: /srv/backups/libvirt/ubuntu20/2025-07-14-172447/ubuntu20-restore-2025-07-14-172447.xml`.

### 7. Rotate Old Backups
- **What it does**: Limits the number of backups to the specified `--max-backups` (default: 6) by deleting older ones.
- **How**: Uses `ls -1dt | tail -n +$((MAX_BACKUPS+1)) | xargs -r rm -rf` to remove directories beyond the retention limit.
- **Output**: Logs the number of retained backups, e.g., `Kept latest 6 backups under /srv/backups/libvirt/ubuntu20/`.

### Crash-Safe Cleanup
- **What it does**: Ensures temporary resources (overlays, snapshot metadata) are removed if the script is interrupted (e.g., Ctrl+C or error).
- **How**: 
  - A `trap` on `EXIT`, `INT`, and `TERM` signals calls a `cleanup` function.
  - If `SNAP_TAKEN=true` and `OVERLAYS_PIVOTED=false`, it:
    - Merges uncommitted overlays with `virsh blockcommit --active --pivot`.
    - Deletes snapshot metadata and overlay files.
  - Uses `|| true` to handle errors gracefully.
- **Output**: Logs cleanup actions, e.g., `cleanup: attempting blockcommit pivot for unfinished snapshot`.

## Usage Example
```bash
./vm_backup.sh \
  --backup-base-dir /srv/backups/libvirt \
  --vm-domain ubuntu20 \
  --compress \
  --new-vm-domain-name ubuntu20-backup1
```
This creates a backup directory like `/srv/backups/libvirt/ubuntu20/2025-07-14-172447/` containing:
- Disk images (e.g., `vda.qcow2`).
- Patched XML (e.g., `ubuntu20-backup1.xml`).
- Snapshot XMLs in `snapshots/` (if any).

## Restoration
```bash
virsh define /srv/backups/libvirt/ubuntu20/2025-07-14-172447/ubuntu20-backup1.xml
virsh start ubuntu20-backup1
for xml in /srv/backups/libvirt/ubuntu20/2025-07-14-172447/snapshots/*.xml; do
  virsh snapshot-create ubuntu20-backup1 --xmlfile "$xml" --redefine
done
```

## Notes
- **Legacy Support**: Designed for `libvirt` ≥ 1.2.9 (e.g., 6.0.0 on Ubuntu 20.04), avoiding modern APIs.
- **Prerequisites**: Requires `virsh`, `xmlstarlet`, and `qemu-img` (for `--compress`).
- **Filesystem Consistency**: For better consistency, install the QEMU Guest Agent and add `--quiesce` to the snapshot command (requires script modification).
- **Backup Size**: Matches the original disk size, reduced with `--compress`.

This script ensures reliable, crash-safe backups for KVM VMs on legacy `libvirt` systems, with a clear and robust workflow.