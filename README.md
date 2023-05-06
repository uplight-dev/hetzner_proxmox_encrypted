# Hetzner proxmox7 install with encrypted LVM
This script installs Proxmox 7 to a provided Hetzner BareMetal Host using RAID 0.

# Usage
```sh
git clone https://github.com/uplight-dev/hetzner_proxmox_encrypted.git
cd hetzner_proxmox_encrypted

cp .env.example .env
# adapt .env accordingly
# start install
. ./install <Hetzner_IP>
```

Please note the Hetzner system must be in RescueMode before running this.

# Limitations
By construction, it currently works only with 2 Drives using RAID 0.
It uses LUKS encryption for both the drives and sets-up Drive2 at reboot time, as Hetzner InstallImage can only 
encrypt first Drive on RAID 0 installations.
See 
https://github.com/hetzneronline/installimage/blob/cc14774999dc19d7724e4c71b1d597da69955db0/install.sh#LL163C3-L163C3

