
 ✘ supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-info  ubuntu20 --snapshotname snapshot1
Name:           snapshot1
Domain:         ubuntu20
Current:        no
State:          running
Location:       internal
Parent:         -
Children:       1
Descendants:    2
Metadata:       yes

 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-dumpxml    ubuntu20 --snapshotname snapshot1
<domainsnapshot>
  <name>snapshot1</name>
  <state>running</state>
  <creationTime>1752416348</creationTime>
  <memory snapshot='internal'/>
  <disks>
    <disk name='vda' snapshot='internal'/>
    <disk name='sda' snapshot='no'/>
  </disks>
  <domain type='kvm'>
    <name>ubuntu20</name>
    <uuid>6005536c-ffa2-456e-aaec-2e5694ec51dc</uuid>
    <metadata>
      <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
        <libosinfo:os id="http://ubuntu.com/ubuntu/20.04"/>
      </libosinfo:libosinfo>
    </metadata>
    <memory unit='KiB'>4194304</memory>
    <currentMemory unit='KiB'>4194304</currentMemory>
    <vcpu placement='static'>4</vcpu>
    <resource>
      <partition>/machine</partition>
    </resource>
    <os>
      <type arch='x86_64' machine='pc-q35-8.2'>hvm</type>
      <boot dev='hd'/>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state='off'/>
    </features>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <clock offset='utc'>
      <timer name='rtc' tickpolicy='catchup'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='hpet' present='no'/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>
    <pm>
      <suspend-to-mem enabled='no'/>
      <suspend-to-disk enabled='no'/>
    </pm>
    <devices>
      <emulator>/usr/bin/qemu-system-x86_64</emulator>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2' discard='unmap'/>
        <source file='/var/lib/libvirt/images/ubuntu20.qcow2'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
      </disk>
      <disk type='file' device='cdrom'>
        <driver name='qemu' type='raw'/>
        <target dev='sda' bus='sata'/>
        <readonly/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
      </disk>
      <controller type='usb' index='0' model='qemu-xhci' ports='15'>
        <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
      </controller>
      <controller type='pci' index='0' model='pcie-root'/>
      <controller type='pci' index='1' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='1' port='0x10'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='2' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='2' port='0x11'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
      </controller>
      <controller type='pci' index='3' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='3' port='0x12'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
      </controller>
      <controller type='pci' index='4' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='4' port='0x13'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
      </controller>
      <controller type='pci' index='5' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='5' port='0x14'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
      </controller>
      <controller type='pci' index='6' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='6' port='0x15'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
      </controller>
      <controller type='pci' index='7' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='7' port='0x16'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
      </controller>
      <controller type='pci' index='8' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='8' port='0x17'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x7'/>
      </controller>
      <controller type='pci' index='9' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='9' port='0x18'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='10' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='10' port='0x19'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x1'/>
      </controller>
      <controller type='pci' index='11' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='11' port='0x1a'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x2'/>
      </controller>
      <controller type='pci' index='12' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='12' port='0x1b'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x3'/>
      </controller>
      <controller type='pci' index='13' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='13' port='0x1c'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x4'/>
      </controller>
      <controller type='pci' index='14' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='14' port='0x1d'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
      </controller>
      <controller type='sata' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
      </controller>
      <controller type='virtio-serial' index='0'>
        <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
      </controller>
      <interface type='network'>
        <mac address='52:54:00:b3:37:46'/>
        <source network='default'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </interface>
      <serial type='pty'>
        <target type='isa-serial' port='0'>
          <model name='isa-serial'/>
        </target>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
      <channel type='unix'>
        <target type='virtio' name='org.qemu.guest_agent.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='1'/>
      </channel>
      <channel type='spicevmc'>
        <target type='virtio' name='com.redhat.spice.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='2'/>
      </channel>
      <input type='tablet' bus='usb'>
        <address type='usb' bus='0' port='1'/>
      </input>
      <input type='mouse' bus='ps2'/>
      <input type='keyboard' bus='ps2'/>
      <graphics type='spice' autoport='yes'>
        <listen type='address'/>
        <image compression='off'/>
      </graphics>
      <sound model='ich9'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
      </sound>
      <audio id='1' type='spice'/>
      <video>
        <model type='virtio' heads='1' primary='yes'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
      </video>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='2'/>
      </redirdev>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='3'/>
      </redirdev>
      <watchdog model='itco' action='reset'/>
      <memballoon model='virtio'>
        <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </memballoon>
      <rng model='virtio'>
        <backend model='random'>/dev/urandom</backend>
        <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
      </rng>
    </devices>
    <seclabel type='dynamic' model='apparmor' relabel='yes'/>
  </domain>
  <inactiveDomain type='kvm'>
    <name>ubuntu20</name>
    <uuid>6005536c-ffa2-456e-aaec-2e5694ec51dc</uuid>
    <metadata>
      <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
        <libosinfo:os id="http://ubuntu.com/ubuntu/20.04"/>
      </libosinfo:libosinfo>
    </metadata>
    <memory unit='KiB'>4194304</memory>
    <currentMemory unit='KiB'>4194304</currentMemory>
    <vcpu placement='static'>4</vcpu>
    <os>
      <type arch='x86_64' machine='pc-q35-8.2'>hvm</type>
      <boot dev='hd'/>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state='off'/>
    </features>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <clock offset='utc'>
      <timer name='rtc' tickpolicy='catchup'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='hpet' present='no'/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>
    <pm>
      <suspend-to-mem enabled='no'/>
      <suspend-to-disk enabled='no'/>
    </pm>
    <devices>
      <emulator>/usr/bin/qemu-system-x86_64</emulator>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2' discard='unmap'/>
        <source file='/var/lib/libvirt/images/ubuntu20.qcow2'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
      </disk>
      <disk type='file' device='cdrom'>
        <driver name='qemu' type='raw'/>
        <target dev='sda' bus='sata'/>
        <readonly/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
      </disk>
      <controller type='usb' index='0' model='qemu-xhci' ports='15'>
        <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
      </controller>
      <controller type='pci' index='0' model='pcie-root'/>
      <controller type='pci' index='1' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='1' port='0x10'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='2' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='2' port='0x11'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
      </controller>
      <controller type='pci' index='3' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='3' port='0x12'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
      </controller>
      <controller type='pci' index='4' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='4' port='0x13'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
      </controller>
      <controller type='pci' index='5' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='5' port='0x14'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
      </controller>
      <controller type='pci' index='6' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='6' port='0x15'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
      </controller>
      <controller type='pci' index='7' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='7' port='0x16'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
      </controller>
      <controller type='pci' index='8' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='8' port='0x17'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x7'/>
      </controller>
      <controller type='pci' index='9' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='9' port='0x18'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='10' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='10' port='0x19'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x1'/>
      </controller>
      <controller type='pci' index='11' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='11' port='0x1a'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x2'/>
      </controller>
      <controller type='pci' index='12' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='12' port='0x1b'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x3'/>
      </controller>
      <controller type='pci' index='13' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='13' port='0x1c'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x4'/>
      </controller>
      <controller type='pci' index='14' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='14' port='0x1d'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
      </controller>
      <controller type='sata' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
      </controller>
      <controller type='virtio-serial' index='0'>
        <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
      </controller>
      <interface type='network'>
        <mac address='52:54:00:b3:37:46'/>
        <source network='default'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </interface>
      <serial type='pty'>
        <target type='isa-serial' port='0'>
          <model name='isa-serial'/>
        </target>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
      <channel type='unix'>
        <target type='virtio' name='org.qemu.guest_agent.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='1'/>
      </channel>
      <channel type='spicevmc'>
        <target type='virtio' name='com.redhat.spice.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='2'/>
      </channel>
      <input type='tablet' bus='usb'>
        <address type='usb' bus='0' port='1'/>
      </input>
      <input type='mouse' bus='ps2'/>
      <input type='keyboard' bus='ps2'/>
      <graphics type='spice' autoport='yes'>
        <listen type='address'/>
        <image compression='off'/>
      </graphics>
      <sound model='ich9'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
      </sound>
      <audio id='1' type='spice'/>
      <video>
        <model type='virtio' heads='1' primary='yes'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
      </video>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='2'/>
      </redirdev>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='3'/>
      </redirdev>
      <watchdog model='itco' action='reset'/>
      <memballoon model='virtio'>
        <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </memballoon>
      <rng model='virtio'>
        <backend model='random'>/dev/urandom</backend>
        <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
      </rng>
    </devices>
  </inactiveDomain>
  <cookie>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <slirpHelper/>
  </cookie>
</domainsnapshot>

 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-info  ubuntu20 --snapshotname snapshot1
Name:           snapshot1
Domain:         ubuntu20
Current:        no
State:          running
Location:       internal
Parent:         -
Children:       1
Descendants:    2
Metadata:       yes

 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-info  ubuntu20-restore-2025-07-13-215447 --snapshotname snapshot1
error: Domain snapshot not found: no domain snapshot with matching name 'snapshot1'

 ✘ supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name   Creation Time   State
-------------------------------

 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name   Creation Time   State
-------------------------------

 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-create --help
  NAME
    snapshot-create - Create a snapshot from XML

  SYNOPSIS
    snapshot-create <domain> [--xmlfile <string>] [--redefine] [--current] [--no-metadata] [--halt] [--disk-only] [--reuse-external] [--quiesce] [--atomic] [--live] [--validate]

  DESCRIPTION
    Create a snapshot (disk and RAM) from XML

  OPTIONS
    [--domain] <string>  domain name, id or uuid
    --xmlfile <string>  domain snapshot XML
    --redefine       redefine metadata for existing snapshot
    --current        with redefine, set current snapshot
    --no-metadata    take snapshot but create no metadata
    --halt           halt domain after snapshot is created
    --disk-only      capture disk state but not vm state
    --reuse-external  reuse any existing external files
    --quiesce        quiesce guest's file systems
    --atomic         require atomic operation
    --live           take a live snapshot
    --validate       validate the XML against the schema


 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-create --redefine --help
  NAME
    snapshot-create - Create a snapshot from XML

  SYNOPSIS
    snapshot-create <domain> [--xmlfile <string>] [--redefine] [--current] [--no-metadata] [--halt] [--disk-only] [--reuse-external] [--quiesce] [--atomic] [--live] [--validate]

  DESCRIPTION
    Create a snapshot (disk and RAM) from XML

  OPTIONS
    [--domain] <string>  domain name, id or uuid
    --xmlfile <string>  domain snapshot XML
    --redefine       redefine metadata for existing snapshot
    --current        with redefine, set current snapshot
    --no-metadata    take snapshot but create no metadata
    --halt           halt domain after snapshot is created
    --disk-only      capture disk state but not vm state
    --reuse-external  reuse any existing external files
    --quiesce        quiesce guest's file systems
    --atomic         require atomic operation
    --live           take a live snapshot
    --validate       validate the XML against the schema


 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile /var/lib/libvirt/qemu/snapshot/ubuntu20/snapshot
1.xml --redefine 
error: Failed to open file '/var/lib/libvirt/qemu/snapshot/ubuntu20/snapshot1.xml': Permission denied

 ✘ supakrit@supakrit-msi  ~/backups/scripts  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile /var/lib/libvirt/qemu/snapshot/ubuntu20/s
napshot1.xml --redefine
error: invalid argument: definition for snapshot snapshot1 must use uuid 6c24bb56-b1bf-4cc1-8d21-9f8bb10344fd

 ✘ supakrit@supakrit-msi  ~/backups/scripts  sudo rm -rf ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots/*
 supakrit@supakrit-msi  ~/backups/scripts  virsh snapshot-list ubuntu20
 Name                       Creation Time               State
-----------------------------------------------------------------------
 backup-2025-07-13-215112   2025-07-13 21:51:12 +0700   disk-snapshot
 snapshot1                  2025-07-13 21:19:08 +0700   running
 snapshot2                  2025-07-13 21:20:37 +0700   running

 supakrit@supakrit-msi  ~/backups/scripts  cd ../artifacts/ubuntu20/2025-07-13-215447/snapshots/
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-dumpxml ubuntu20 snapshot1
<domainsnapshot>
  <name>snapshot1</name>
  <state>running</state>
  <creationTime>1752416348</creationTime>
  <memory snapshot='internal'/>
  <disks>
    <disk name='vda' snapshot='internal'/>
    <disk name='sda' snapshot='no'/>
  </disks>
  <domain type='kvm'>
    <name>ubuntu20</name>
    <uuid>6005536c-ffa2-456e-aaec-2e5694ec51dc</uuid>
    <metadata>
      <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
        <libosinfo:os id="http://ubuntu.com/ubuntu/20.04"/>
      </libosinfo:libosinfo>
    </metadata>
    <memory unit='KiB'>4194304</memory>
    <currentMemory unit='KiB'>4194304</currentMemory>
    <vcpu placement='static'>4</vcpu>
    <resource>
      <partition>/machine</partition>
    </resource>
    <os>
      <type arch='x86_64' machine='pc-q35-8.2'>hvm</type>
      <boot dev='hd'/>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state='off'/>
    </features>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <clock offset='utc'>
      <timer name='rtc' tickpolicy='catchup'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='hpet' present='no'/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>
    <pm>
      <suspend-to-mem enabled='no'/>
      <suspend-to-disk enabled='no'/>
    </pm>
    <devices>
      <emulator>/usr/bin/qemu-system-x86_64</emulator>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2' discard='unmap'/>
        <source file='/var/lib/libvirt/images/ubuntu20.qcow2'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
      </disk>
      <disk type='file' device='cdrom'>
        <driver name='qemu' type='raw'/>
        <target dev='sda' bus='sata'/>
        <readonly/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
      </disk>
      <controller type='usb' index='0' model='qemu-xhci' ports='15'>
        <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
      </controller>
      <controller type='pci' index='0' model='pcie-root'/>
      <controller type='pci' index='1' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='1' port='0x10'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='2' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='2' port='0x11'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
      </controller>
      <controller type='pci' index='3' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='3' port='0x12'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
      </controller>
      <controller type='pci' index='4' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='4' port='0x13'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
      </controller>
      <controller type='pci' index='5' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='5' port='0x14'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
      </controller>
      <controller type='pci' index='6' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='6' port='0x15'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
      </controller>
      <controller type='pci' index='7' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='7' port='0x16'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
      </controller>
      <controller type='pci' index='8' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='8' port='0x17'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x7'/>
      </controller>
      <controller type='pci' index='9' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='9' port='0x18'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='10' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='10' port='0x19'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x1'/>
      </controller>
      <controller type='pci' index='11' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='11' port='0x1a'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x2'/>
      </controller>
      <controller type='pci' index='12' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='12' port='0x1b'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x3'/>
      </controller>
      <controller type='pci' index='13' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='13' port='0x1c'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x4'/>
      </controller>
      <controller type='pci' index='14' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='14' port='0x1d'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
      </controller>
      <controller type='sata' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
      </controller>
      <controller type='virtio-serial' index='0'>
        <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
      </controller>
      <interface type='network'>
        <mac address='52:54:00:b3:37:46'/>
        <source network='default'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </interface>
      <serial type='pty'>
        <target type='isa-serial' port='0'>
          <model name='isa-serial'/>
        </target>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
      <channel type='unix'>
        <target type='virtio' name='org.qemu.guest_agent.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='1'/>
      </channel>
      <channel type='spicevmc'>
        <target type='virtio' name='com.redhat.spice.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='2'/>
      </channel>
      <input type='tablet' bus='usb'>
        <address type='usb' bus='0' port='1'/>
      </input>
      <input type='mouse' bus='ps2'/>
      <input type='keyboard' bus='ps2'/>
      <graphics type='spice' autoport='yes'>
        <listen type='address'/>
        <image compression='off'/>
      </graphics>
      <sound model='ich9'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
      </sound>
      <audio id='1' type='spice'/>
      <video>
        <model type='virtio' heads='1' primary='yes'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
      </video>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='2'/>
      </redirdev>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='3'/>
      </redirdev>
      <watchdog model='itco' action='reset'/>
      <memballoon model='virtio'>
        <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </memballoon>
      <rng model='virtio'>
        <backend model='random'>/dev/urandom</backend>
        <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
      </rng>
    </devices>
    <seclabel type='dynamic' model='apparmor' relabel='yes'/>
  </domain>
  <inactiveDomain type='kvm'>
    <name>ubuntu20</name>
    <uuid>6005536c-ffa2-456e-aaec-2e5694ec51dc</uuid>
    <metadata>
      <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
        <libosinfo:os id="http://ubuntu.com/ubuntu/20.04"/>
      </libosinfo:libosinfo>
    </metadata>
    <memory unit='KiB'>4194304</memory>
    <currentMemory unit='KiB'>4194304</currentMemory>
    <vcpu placement='static'>4</vcpu>
    <os>
      <type arch='x86_64' machine='pc-q35-8.2'>hvm</type>
      <boot dev='hd'/>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state='off'/>
    </features>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <clock offset='utc'>
      <timer name='rtc' tickpolicy='catchup'/>
      <timer name='pit' tickpolicy='delay'/>
      <timer name='hpet' present='no'/>
    </clock>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>
    <pm>
      <suspend-to-mem enabled='no'/>
      <suspend-to-disk enabled='no'/>
    </pm>
    <devices>
      <emulator>/usr/bin/qemu-system-x86_64</emulator>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2' discard='unmap'/>
        <source file='/var/lib/libvirt/images/ubuntu20.qcow2'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
      </disk>
      <disk type='file' device='cdrom'>
        <driver name='qemu' type='raw'/>
        <target dev='sda' bus='sata'/>
        <readonly/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
      </disk>
      <controller type='usb' index='0' model='qemu-xhci' ports='15'>
        <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
      </controller>
      <controller type='pci' index='0' model='pcie-root'/>
      <controller type='pci' index='1' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='1' port='0x10'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='2' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='2' port='0x11'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
      </controller>
      <controller type='pci' index='3' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='3' port='0x12'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
      </controller>
      <controller type='pci' index='4' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='4' port='0x13'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
      </controller>
      <controller type='pci' index='5' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='5' port='0x14'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
      </controller>
      <controller type='pci' index='6' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='6' port='0x15'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
      </controller>
      <controller type='pci' index='7' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='7' port='0x16'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
      </controller>
      <controller type='pci' index='8' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='8' port='0x17'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x7'/>
      </controller>
      <controller type='pci' index='9' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='9' port='0x18'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0' multifunction='on'/>
      </controller>
      <controller type='pci' index='10' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='10' port='0x19'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x1'/>
      </controller>
      <controller type='pci' index='11' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='11' port='0x1a'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x2'/>
      </controller>
      <controller type='pci' index='12' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='12' port='0x1b'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x3'/>
      </controller>
      <controller type='pci' index='13' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='13' port='0x1c'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x4'/>
      </controller>
      <controller type='pci' index='14' model='pcie-root-port'>
        <model name='pcie-root-port'/>
        <target chassis='14' port='0x1d'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
      </controller>
      <controller type='sata' index='0'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
      </controller>
      <controller type='virtio-serial' index='0'>
        <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
      </controller>
      <interface type='network'>
        <mac address='52:54:00:b3:37:46'/>
        <source network='default'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </interface>
      <serial type='pty'>
        <target type='isa-serial' port='0'>
          <model name='isa-serial'/>
        </target>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
      <channel type='unix'>
        <target type='virtio' name='org.qemu.guest_agent.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='1'/>
      </channel>
      <channel type='spicevmc'>
        <target type='virtio' name='com.redhat.spice.0'/>
        <address type='virtio-serial' controller='0' bus='0' port='2'/>
      </channel>
      <input type='tablet' bus='usb'>
        <address type='usb' bus='0' port='1'/>
      </input>
      <input type='mouse' bus='ps2'/>
      <input type='keyboard' bus='ps2'/>
      <graphics type='spice' autoport='yes'>
        <listen type='address'/>
        <image compression='off'/>
      </graphics>
      <sound model='ich9'>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
      </sound>
      <audio id='1' type='spice'/>
      <video>
        <model type='virtio' heads='1' primary='yes'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
      </video>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='2'/>
      </redirdev>
      <redirdev bus='usb' type='spicevmc'>
        <address type='usb' bus='0' port='3'/>
      </redirdev>
      <watchdog model='itco' action='reset'/>
      <memballoon model='virtio'>
        <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </memballoon>
      <rng model='virtio'>
        <backend model='random'>/dev/urandom</backend>
        <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
      </rng>
    </devices>
  </inactiveDomain>
  <cookie>
    <cpu mode='host-passthrough' check='none' migratable='on'/>
    <slirpHelper/>
  </cookie>
</domainsnapshot>

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-dumpxml ubuntu20 snapshot1 > snapshot1.xml
zsh: permission denied: snapshot1.xml
 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-dumpxml ubuntu20 snapshot1 > snapshot1.xml
zsh: permission denied: snapshot1.xml
 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-dumpxml ubuntu20 snapshot1 > snapshot1.xml
zsh: permission denied: snapshot1.xml
 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo chmod -R 777 ../snapshots/
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-dumpxml ubuntu20 snapshot1 > snapshot1.xml
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-dumpxml ubuntu20 snapshot2 > snapshot2.xml
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
error: invalid argument: definition for snapshot snapshot1 must use uuid 6c24bb56-b1bf-4cc1-8d21-9f8bb10344fd

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  code .
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
error: invalid argument: definition for snapshot snapshot1 must use uuid 6c24bb56-b1bf-4cc1-8d21-9f8bb10344fd

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh list --all
 Id   Name                                 State
-----------------------------------------------------
 7    ubuntu20                             running
 -    ubuntu20-restore-2025-07-13-215447   shut off

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh --help

virsh [options]... [<command_string>]
virsh [options]... <command> [args...]

  options:
    -c | --connect=URI      hypervisor connection URI
    -d | --debug=NUM        debug level [0-4]
    -e | --escape <char>    set escape sequence for console
    -h | --help             this help
    -k | --keepalive-interval=NUM
                            keepalive interval in seconds, 0 for disable
    -K | --keepalive-count=NUM
                            number of possible missed keepalive messages
    -l | --log=FILE         output logging to file
    -q | --quiet            quiet mode
    -r | --readonly         connect readonly
    -t | --timing           print timing information
    -v                      short version
    -V                      long version
         --version[=TYPE]   version, TYPE is short or long (default short)
  commands (non interactive mode):

 Domain Management (help keyword 'domain')
    attach-device                  attach device from an XML file
    attach-disk                    attach disk device
    attach-interface               attach network interface
    autostart                      autostart a domain
    blkdeviotune                   Set or query a block device I/O tuning parameters.
    blkiotune                      Get or set blkio parameters
    blockcommit                    Start a block commit operation.
    blockcopy                      Start a block copy operation.
    blockjob                       Manage active block operations
    blockpull                      Populate a disk from its backing image.
    blockresize                    Resize block device of domain.
    change-media                   Change media of CD or floppy drive
    console                        connect to the guest console
    cpu-stats                      show domain cpu statistics
    create                         create a domain from an XML file
    define                         define (but don't start) a domain from an XML file
    desc                           show or set domain's description or title
    destroy                        destroy (stop) a domain
    detach-device                  detach device from an XML file
    detach-device-alias            detach device from an alias
    detach-disk                    detach disk device
    detach-interface               detach network interface
    domdisplay                     domain display connection URI
    domfsfreeze                    Freeze domain's mounted filesystems.
    domfsthaw                      Thaw domain's mounted filesystems.
    domfsinfo                      Get information of domain's mounted filesystems.
    domfstrim                      Invoke fstrim on domain's mounted filesystems.
    domhostname                    print the domain's hostname
    domid                          convert a domain name or UUID to domain id
    domif-setlink                  set link state of a virtual interface
    domiftune                      get/set parameters of a virtual interface
    domjobabort                    abort active domain job
    domjobinfo                     domain job information
    domlaunchsecinfo               Get domain launch security info
    domsetlaunchsecstate           Set domain launch security state
    domname                        convert a domain id or UUID to domain name
    domrename                      rename a domain
    dompmsuspend                   suspend a domain gracefully using power management functions
    dompmwakeup                    wakeup a domain from pmsuspended state
    domuuid                        convert a domain name or id to domain UUID
    domxml-from-native             Convert native config to domain XML
    domxml-to-native               Convert domain XML to native config
    dump                           dump the core of a domain to a file for analysis
    dumpxml                        domain information in XML
    edit                           edit XML configuration for a domain
    get-user-sshkeys               list authorized SSH keys for given user (via agent)
    inject-nmi                     Inject NMI to the guest
    iothreadinfo                   view domain IOThreads
    iothreadpin                    control domain IOThread affinity
    iothreadadd                    add an IOThread to the guest domain
    iothreadset                    modifies an existing IOThread of the guest domain
    iothreaddel                    delete an IOThread from the guest domain
    send-key                       Send keycodes to the guest
    send-process-signal            Send signals to processes
    lxc-enter-namespace            LXC Guest Enter Namespace
    managedsave                    managed save of a domain state
    managedsave-remove             Remove managed save of a domain
    managedsave-edit               edit XML for a domain's managed save state file
    managedsave-dumpxml            Domain information of managed save state file in XML
    managedsave-define             redefine the XML for a domain's managed save state file
    memtune                        Get or set memory parameters
    perf                           Get or set perf event
    metadata                       show or set domain's custom XML metadata
    migrate                        migrate domain to another host
    migrate-setmaxdowntime         set maximum tolerable downtime
    migrate-getmaxdowntime         get maximum tolerable downtime
    migrate-compcache              get/set compression cache size
    migrate-setspeed               Set the maximum migration bandwidth
    migrate-getspeed               Get the maximum migration bandwidth
    migrate-postcopy               Switch running migration from pre-copy to post-copy
    numatune                       Get or set numa parameters
    qemu-attach                    QEMU Attach
    qemu-monitor-command           QEMU Monitor Command
    qemu-monitor-event             QEMU Monitor Events
    qemu-agent-command             QEMU Guest Agent Command
    guest-agent-timeout            Set the guest agent timeout
    reboot                         reboot a domain
    reset                          reset a domain
    restore                        restore a domain from a saved state in a file
    resume                         resume a domain
    save                           save a domain state to a file
    save-image-define              redefine the XML for a domain's saved state file
    save-image-dumpxml             saved state domain information in XML
    save-image-edit                edit XML for a domain's saved state file
    schedinfo                      show/set scheduler parameters
    screenshot                     take a screenshot of a current domain console and store it into a file
    set-lifecycle-action           change lifecycle actions
    set-user-sshkeys               manipulate authorized SSH keys file for given user (via agent)
    set-user-password              set the user password inside the domain
    setmaxmem                      change maximum memory limit
    setmem                         change memory allocation
    setvcpus                       change number of virtual CPUs
    shutdown                       gracefully shutdown a domain
    start                          start a (previously defined) inactive domain
    suspend                        suspend a domain
    ttyconsole                     tty console
    undefine                       undefine a domain
    update-device                  update device from an XML file
    update-memory-device           update memory device of a domain
    vcpucount                      domain vcpu counts
    vcpuinfo                       detailed domain vcpu information
    vcpupin                        control or query domain vcpu affinity
    emulatorpin                    control or query domain emulator affinity
    vncdisplay                     vnc display
    guestvcpus                     query or modify state of vcpu in the guest (via agent)
    setvcpu                        attach/detach vcpu or groups of threads
    domblkthreshold                set the threshold for block-threshold event for a given block device or it's backing chain element
    guestinfo                      query information about the guest (via agent)
    domdirtyrate-calc              Calculate a vm's memory dirty rate
    dom-fd-associate               associate a FD with a domain

 Domain Monitoring (help keyword 'monitor')
    domblkerror                    Show errors on block devices
    domblkinfo                     domain block device size information
    domblklist                     list all domain blocks
    domblkstat                     get device block stats for a domain
    domcontrol                     domain control interface state
    domif-getlink                  get link state of a virtual interface
    domifaddr                      Get network interfaces' addresses for a running domain
    domiflist                      list all domain virtual interfaces
    domifstat                      get network interface stats for a domain
    dominfo                        domain information
    dommemstat                     get memory statistics for a domain
    domstate                       domain state
    domstats                       get statistics about one or multiple domains
    domtime                        domain time
    list                           list domains

 Domain Events (help keyword 'events')
    event                          Domain Events

 Host and Hypervisor (help keyword 'host')
    allocpages                     Manipulate pages pool size
    capabilities                   capabilities
    cpu-baseline                   compute baseline CPU
    cpu-compare                    compare host CPU with a CPU described by an XML file
    cpu-models                     CPU models
    domcapabilities                domain capabilities
    freecell                       NUMA free memory
    freepages                      NUMA free pages
    hostname                       print the hypervisor hostname
    hypervisor-cpu-baseline        compute baseline CPU usable by a specific hypervisor
    hypervisor-cpu-compare         compare a CPU with the CPU created by a hypervisor on the host
    maxvcpus                       connection vcpu maximum
    node-memory-tune               Get or set node memory parameters
    nodecpumap                     node cpu map
    nodecpustats                   Prints cpu stats of the node.
    nodeinfo                       node information
    nodememstats                   Prints memory stats of the node.
    nodesevinfo                    node SEV information
    nodesuspend                    suspend the host node for a given time duration
    sysinfo                        print the hypervisor sysinfo
    uri                            print the hypervisor canonical URI
    version                        show version

 Checkpoint (help keyword 'checkpoint')
    checkpoint-create              Create a checkpoint from XML
    checkpoint-create-as           Create a checkpoint from a set of args
    checkpoint-delete              Delete a domain checkpoint
    checkpoint-dumpxml             Dump XML for a domain checkpoint
    checkpoint-edit                edit XML for a checkpoint
    checkpoint-info                checkpoint information
    checkpoint-list                List checkpoints for a domain
    checkpoint-parent              Get the name of the parent of a checkpoint

 Interface (help keyword 'interface')
    iface-begin                    create a snapshot of current interfaces settings, which can be later committed (iface-commit) or restored (iface-rollback)
    iface-bridge                   create a bridge device and attach an existing network device to it
    iface-commit                   commit changes made since iface-begin and free restore point
    iface-define                   define an inactive persistent physical host interface or modify an existing persistent one from an XML file
    iface-destroy                  destroy a physical host interface (disable it / "if-down")
    iface-dumpxml                  interface information in XML
    iface-edit                     edit XML configuration for a physical host interface
    iface-list                     list physical host interfaces
    iface-mac                      convert an interface name to interface MAC address
    iface-name                     convert an interface MAC address to interface name
    iface-rollback                 rollback to previous saved configuration created via iface-begin
    iface-start                    start a physical host interface (enable it / "if-up")
    iface-unbridge                 undefine a bridge device after detaching its device(s)
    iface-undefine                 undefine a physical host interface (remove it from configuration)

 Network Filter (help keyword 'filter')
    nwfilter-define                define or update a network filter from an XML file
    nwfilter-dumpxml               network filter information in XML
    nwfilter-edit                  edit XML configuration for a network filter
    nwfilter-list                  list network filters
    nwfilter-undefine              undefine a network filter
    nwfilter-binding-create        create a network filter binding from an XML file
    nwfilter-binding-delete        delete a network filter binding
    nwfilter-binding-dumpxml       network filter information in XML
    nwfilter-binding-list          list network filter bindings

 Networking (help keyword 'network')
    net-autostart                  autostart a network
    net-create                     create a network from an XML file
    net-define                     define an inactive persistent virtual network or modify an existing persistent one from an XML file
    net-desc                       show or set network's description or title
    net-destroy                    destroy (stop) a network
    net-dhcp-leases                print lease info for a given network
    net-dumpxml                    network information in XML
    net-edit                       edit XML configuration for a network
    net-event                      Network Events
    net-info                       network information
    net-list                       list networks
    net-metadata                   show or set network's custom XML metadata
    net-name                       convert a network UUID to network name
    net-start                      start a (previously defined) inactive network
    net-undefine                   undefine a persistent network
    net-update                     update parts of an existing network's configuration
    net-uuid                       convert a network name to network UUID
    net-port-list                  list network ports
    net-port-create                create a network port from an XML file
    net-port-dumpxml               network port information in XML
    net-port-delete                delete the specified network port

 Node Device (help keyword 'nodedev')
    nodedev-create                 create a device defined by an XML file on the node
    nodedev-destroy                destroy (stop) a device on the node
    nodedev-detach                 detach node device from its device driver
    nodedev-dumpxml                node device details in XML
    nodedev-list                   enumerate devices on this host
    nodedev-reattach               reattach node device to its device driver
    nodedev-reset                  reset node device
    nodedev-event                  Node Device Events
    nodedev-define                 Define a device by an xml file on a node
    nodedev-undefine               Undefine an inactive node device
    nodedev-start                  Start an inactive node device
    nodedev-autostart              autostart a defined node device
    nodedev-info                   node device information

 Secret (help keyword 'secret')
    secret-define                  define or modify a secret from an XML file
    secret-dumpxml                 secret attributes in XML
    secret-event                   Secret Events
    secret-get-value               Output a secret value
    secret-list                    list secrets
    secret-set-value               set a secret value
    secret-undefine                undefine a secret

 Snapshot (help keyword 'snapshot')
    snapshot-create                Create a snapshot from XML
    snapshot-create-as             Create a snapshot from a set of args
    snapshot-current               Get or set the current snapshot
    snapshot-delete                Delete a domain snapshot
    snapshot-dumpxml               Dump XML for a domain snapshot
    snapshot-edit                  edit XML for a snapshot
    snapshot-info                  snapshot information
    snapshot-list                  List snapshots for a domain
    snapshot-parent                Get the name of the parent of a snapshot
    snapshot-revert                Revert a domain to a snapshot

 Backup (help keyword 'backup')
    backup-begin                   Start a disk backup of a live domain
    backup-dumpxml                 Dump XML for an ongoing domain block backup job

 Storage Pool (help keyword 'pool')
    find-storage-pool-sources-as   find potential storage pool sources
    find-storage-pool-sources      discover potential storage pool sources
    pool-autostart                 autostart a pool
    pool-build                     build a pool
    pool-create-as                 create a pool from a set of args
    pool-create                    create a pool from an XML file
    pool-define-as                 define a pool from a set of args
    pool-define                    define an inactive persistent storage pool or modify an existing persistent one from an XML file
    pool-delete                    delete a pool
    pool-destroy                   destroy (stop) a pool
    pool-dumpxml                   pool information in XML
    pool-edit                      edit XML configuration for a storage pool
    pool-info                      storage pool information
    pool-list                      list pools
    pool-name                      convert a pool UUID to pool name
    pool-refresh                   refresh a pool
    pool-start                     start a (previously defined) inactive pool
    pool-undefine                  undefine an inactive pool
    pool-uuid                      convert a pool name to pool UUID
    pool-event                     Storage Pool Events
    pool-capabilities              storage pool capabilities

 Storage Volume (help keyword 'volume')
    vol-clone                      clone a volume.
    vol-create-as                  create a volume from a set of args
    vol-create                     create a vol from an XML file
    vol-create-from                create a vol, using another volume as input
    vol-delete                     delete a vol
    vol-download                   download volume contents to a file
    vol-dumpxml                    vol information in XML
    vol-info                       storage vol information
    vol-key                        returns the volume key for a given volume name or path
    vol-list                       list vols
    vol-name                       returns the volume name for a given volume key or path
    vol-path                       returns the volume path for a given volume name or key
    vol-pool                       returns the storage pool for a given volume key or path
    vol-resize                     resize a vol
    vol-upload                     upload file contents to a volume
    vol-wipe                       wipe a vol

 Virsh itself (help keyword 'virsh')
    cd                             change the current directory
    echo                           echo arguments. Used for internal testing.
    exit                           quit this interactive terminal
    help                           print help
    pwd                            print the current directory
    quit                           quit this interactive terminal
    connect                        (re)connect to hypervisor


  (specify help <group> for details about the commands in the group)

  (specify help <command> for details about the command)

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
Domain snapshot snapshot1 created from 'snapshot1.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot2.xml --redefine
Domain snapshot snapshot2 created from 'snapshot2.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name        Creation Time               State
--------------------------------------------------
 snapshot1   2025-07-13 21:19:08 +0700   running
 snapshot2   2025-07-13 21:20:37 +0700   running

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name        Creation Time               State
--------------------------------------------------
 snapshot1   2025-07-13 21:19:08 +0700   running
 snapshot2   2025-07-13 21:20:37 +0700   running

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name        Creation Time               State
--------------------------------------------------
 snapshot1   2025-07-13 21:19:08 +0700   running
 snapshot2   2025-07-13 21:20:37 +0700   running

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
error: XML error: memory state cannot be saved with offline or disk-only snapshot

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot1.xml
error: Domain snapshot not found: no domain snapshot with matching name 'snapshot1.xml'

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot1
Domain snapshot snapshot1 deleted

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot2
Domain snapshot snapshot2 deleted

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
error: XML error: memory state cannot be saved with offline or disk-only snapshot

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile sn
apshot1.xml --redefine
Domain snapshot snapshot1 created from 'snapshot1.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot2.xml --redefine
Domain snapshot snapshot2 created from 'snapshot2.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh start ubuntu20-restore-2025-07-13-215447
Domain 'ubuntu20-restore-2025-07-13-215447' started

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot2
error: Failed to delete snapshot snapshot2
error: Operation not supported: disk image 'vda' for internal snapshot 'snapshot2' is not the same as disk image currently used by VM

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-edit snapshot1.xml 
error: failed to get domain 'snapshot1.xml'

 ✘ supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot2
Domain snapshot snapshot2 deleted

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-delete  ubuntu20-restore-2025-07-13-215447 snapshot1
Domain snapshot snapshot1 deleted

 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot1.xml --redefine
Domain snapshot snapshot1 created from 'snapshot1.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  sudo virsh snapshot-create ubuntu20-restore-2025-07-13-215447 --xmlfile snap
shot2.xml --redefine
Domain snapshot snapshot2 created from 'snapshot2.xml'
 supakrit@supakrit-msi  ~/backups/artifacts/ubuntu20/2025-07-13-215447/snapshots  virsh snapshot-list ubuntu20-restore-2025-07-13-215447
 Name        Creation Time               State
--------------------------------------------------
 snapshot1   2025-07-13 21:19:08 +0700   running
 snapshot2   2025-07-13 21:20:37 +0700   running