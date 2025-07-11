# vm_backup.sh

A simple, beginner-friendly Bash script to take live (or offline) backups of KVM virtual machines.  
It captures all disk devices (but skips read-only CD-ROMs), creates a consistent point-in-time backup, optionally compresses the QCOW2 images, dumps & patches the domain XML, and keeps only the N most recent backups.

---

## Table of Contents

1. [Features](#features)  
2. [Prerequisites](#prerequisites)  
3. [Installation](#installation)  
4. [Usage](#usage)  
5. [How It Works](#how-it-works)  
6. [Restoring a Backup](#restoring-a-backup)  
7. [Configuration Options](#configuration-options)  
8. [Troubleshooting](#troubleshooting)  

---

## Features

- **Live snapshot** of running VMs via `virsh snapshot-create-as`  
- **Offline copy** for powered-off VMs  
- **Skip** CD-ROM (`.iso`) devices  
- **Sparse copy** of QCOW2 disks to preserve holes  
- **Optional internal compression** of QCOW2 (`--compress`) to save space  
- **Automatic XML dump & patch** (new name + fresh UUID + updated disk paths)  
- **Rotation** of old backups, keeping only the N most recent  

---

## Prerequisites

- **Host OS**: Linux with KVM/libvirt installed  
- **Commands**:
  - `bash`  
  - `virsh`  
  - `qemu-img` (from `qemu-utils`; required only if using `--compress`)  
  - Standard Unix tools: `awk`, `sed`, `cp`, `mv`, `ls`, `xargs`  

Install missing tools on Debian/Ubuntu:
```bash
sudo apt update
sudo apt install qemu-utils libvirt-clients
````

---

## Installation

1. Copy the script to `/usr/local/bin/vm_backup.sh` (or any folder in your `$PATH`):

   ```bash
   sudo cp vm_backup.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/vm_backup.sh
   ```

2. Verify it’s executable:

   ```bash
   vm_backup.sh --help
   ```

---

## Usage

```bash
vm_backup.sh \
  --backup-base-dir /mnt/backups \
  --vm-domain myvm \
  [--max-backups 5] \
  [--compress]
```

* `--backup-base-dir DIR`
  Base folder under which backups are stored.
  Each VM will have its own subdirectory:
  `/mnt/backups/<vm-domain>/<timestamp>/`

* `--vm-domain NAME`
  The libvirt domain name of your VM (as shown by `virsh list --all`).

* `--max-backups N` (optional, default 6)
  How many timestamped backups to keep per VM.

* `--compress` (optional)
  Enable internal QCOW2 compression (`qemu-img convert -c`).

---

## How It Works

1. **Enumerate disks**
   Uses `virsh domblklist --details` + `awk` to list all **`disk`** devices (skips CD-ROMs).

2. **Snapshot (if running)**
   If the VM is `running`, creates an external overlay with
   `virsh snapshot-create-as --disk-only --atomic --no-metadata`.
   New writes go into `<dev>.snap.qcow2`; the base QCOW2 is frozen.

3. **Copy & (optional) compress**

   * **Sparse copy**: `cp --sparse=always` preserves holes in the QCOW2.
   * **Optional compression**: if `--compress` is set, `qemu-img convert -O qcow2 -c`
     compresses the image internally (may take time on large disks).

4. **Merge overlay**
   For a running VM, `virsh blockcommit --active --pivot` replays and removes overlays.

5. **Dump & patch XML**

   * `virsh dumpxml` into `<vm>-restore-<timestamp>.xml`
   * Removes the old `<uuid>`, updates `<name>` to `vm-restore-<timestamp>`,
     and rewrites each `<source file='…'>` to point at the new QCOW2.

6. **Rotate old backups**
   Keeps only the newest N timestamped directories under
   `/mnt/backups/<vm-domain>/`.

---

## Restoring a Backup

```bash
# Define the restored VM (uses the <name> in the patched XML)
virsh define /mnt/backups/myvm/2025-07-11-153000/myvm-restore-2025-07-11-153000.xml

# Start it
virsh start myvm-restore-2025-07-11-153000
```

Or import directly:

```bash
virt-install \
  --name myvm-restore-2025-07-11-153000 \
  --ram 4096 --vcpus 2 \
  --disk path=/mnt/backups/myvm/2025-07-11-153000/vda.qcow2,format=qcow2 \
  --import \
  --network network=default \
  --os-variant ubuntu20.04 \
  --noautoconsole
```

---

## Configuration Options

* **`--backup-base-dir`**
  Choose a high-capacity, reliable storage location (e.g., a NAS mount).

* **`--vm-domain`**
  Must match the exact libvirt domain name.

* **`--max-backups`**
  Tune based on available space vs. retention policy.

* **`--compress`**
  Enable or disable internal QCOW2 compression.

---

## Troubleshooting

* **“ERROR: No disk devices found”**
  Check `virsh domblklist <vm> --details` for correct device types.

* **Snapshot command fails**
  Ensure QEMU guest agent is installed for `--quiesce`, or run while the VM is off.

* **Backup size still very large**
  If not using `--compress`, the QCOW2 remains sparse but uncompressed; use `--compress`.

* **Restore domain name clashes**
  The script auto-assigns `<name>vm-restore-…</name>` and strips `<uuid>` to avoid conflicts.

---

> With this updated script and README, you can choose whether to compress your backups or keep them sparse only—perfect for balancing speed vs. space!
