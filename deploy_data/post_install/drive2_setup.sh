#!/bin/bash
log() {
  echo "********************* $1 ********************"
}

wipefs -a /dev/sdb

apt install -y parted

parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary 0% 100%
mkfs.ext4 /dev/sdb1

apt update && apt install -y lvm2 cryptsetup
echo -e "@ROOT_PWD@" | cryptsetup -q -y -v luksFormat /dev/sdb1
echo -e "@ROOT_PWD@" | cryptsetup open /dev/sdb1 sdb1_crypt

pvcreate /dev/mapper/sdb1_crypt
vgcreate vg1 /dev/mapper/sdb1_crypt
lvcreate -l 100%FREE --name ext vg1

mkfs.ext4 /dev/vg1/ext

mkdir /mnt/ext
echo '/dev/vg1/ext /mnt/ext ext4 defaults 0 0' >> /etc/fstab
mount /mnt/ext

tee -a /etc/pve/storage.cfg << EOF > /dev/null
lvmthin: vg1
  content images, iso
  thinpool data
EOF

log "add vg1/ext to crypttab"
UUID=$(cryptsetup luksUUID /dev/sdb1)
echo "sdb1_crypt UUID=$UUID none luks,discard,initramfs" >> /etc/crypttab

log "update initramfs"
sudo update-initramfs -c -k $(uname -r)

log "restart PVE"
systemctl restart pve-cluster

log "INSTALL COMPLETE!"
