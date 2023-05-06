# Hetzner proxmox7 install with encrypted LVM
This script installs Proxmox 7 to a provided Hetzner BareMetal Host using RAID 0.
It uses LUKS encryption for both the drives.

# Usage
```sh
git clone https://github.com/uplight-dev/hetzner_proxmox_encrypted.git
cd hetzner_proxmox_encrypted

mkdir security && cd security
# generate strong passwords for:
nano disk_enc.pwd ssh.pwd root.pwd

# generate a ssh-key into security/ssh-keys with name vmbox
ssh-keygen -C vmbox -f ssh-key/vmbox

cp .env.example .env
# adapt .env accordingly
# start install
. ./install <Hetzner_IP>
```

Please note the Hetzner system must be in RescueMode before running this.

# Limitations
1. It is designed to work only with 2 Drives using RAID 0.
Drive2 is not encrypted by Hetzner installimage script via setup.conf of installimage script as Hetzner InstallImage can only encrypt first Drive on RAID 0 installations.
See 
https://github.com/hetzneronline/installimage/blob/cc14774999dc19d7724e4c71b1d597da69955db0/install.sh#LL163C3-L163C3

2. The encryption of the second drive takes place after the first reboot as doing this during post-install script of Hetzner causes issue with update-initramfs command(possible issue with chroot, to investigate further)
