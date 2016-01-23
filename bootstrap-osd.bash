#!/bin/bash

useradd -d /home/ceph -s /bin/bash -m ceph
echo "ceph:ceph" | chpasswd
echo "ceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph

mkdir /home/ceph/.ssh
chmod 700 /home/ceph/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoc+s56EuX7DXURRCbGiezaynKRS8MRWogkSMvxF4Z6M+ebRGJTFkoGxlEGeBH5Hf+yTfM/QIywIj/v5I8Pi7QNZDE2ttIucnloyFnMHHZVTF7al/JjLqYAaerYpQ9yCuBoFjEKdE4m04mCSrg3Tsk7t6eWBniLqTdCDr4ZiuAvf4fSPHca+3Jp8p2all3Lmny/doYxDhpucv3rQ3UAx+IH07rLJU4eJSMWqwGRz0NZY1qCWByl857dP9EFMiXU1g8OtDnAZo7V107V6DCc6HVBdiGLz5Ydtrbq5B2SHxgzKTgJEmfehcZXqNeos0chf4056ocCGg1Cvk/xWfo8mlZ cephuser@ceph-admin" > /home/ceph/.ssh/authorized_keys
chmod 600 /home/ceph/.ssh/authorized_keys
chown -R ceph:ceph /home/ceph/

# Generate keyfile for luks
dd if=/dev/urandom of=/root/keyfile bs=1024 count=4
chmod 0400 /root/keyfile

wget -q -O- 'https://git.ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
apt-add-repository 'deb http://download.ceph.com/debian-hammer/ trusty main'
apt-get update && apt-get install -y ntp ntpdate ntp-doc xfsprogs
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
apt-get remove -y apparmor

# Installation  repo Salt
add-apt-repository ppa:saltstack/salt2014-7 -y
# Installation repo calamari
echo "deb http://download.ceph.com/calamari/1.3.1/ubuntu/trusty/ trusty main" >/etc/apt/sources.list.d/calamari.list
# Installation salt-master and minion and dependencies
apt-get update -y   --allow-unauthenticated && apt-get install --allow-unauthenticated -y git python-virtualenv


parted -s /dev/sdb mklabel gpt
parted -s /dev/sdb mkpart primary 0% 50%
parted -s /dev/sdb mkpart primary 51% 100%
#cryptsetup -v -q luksFormat /dev/sdb1 /root/keyfile
#cryptsetup -v -q luksFormat /dev/sdb2 /root/keyfile
#cryptsetup luksOpen /dev/sdb1 journal0 --key-file /root/keyfile
#cryptsetup luksOpen /dev/sdb2 journal1 --key-file /root/keyfile

parted -s /dev/sdc mklabel gpt
parted -s /dev/sdc mkpart primary xfs 0% 100%
cryptsetup -v -q  luksFormat /dev/sdc1 /root/keyfile
cryptsetup luksOpen /dev/sdc1 osd0 --key-file /root/keyfile
mkfs.xfs /dev/mapper/osd0


parted -s /dev/sdd mklabel gpt
parted -s /dev/sdd mkpart primary xfs 0% 100%
cryptsetup -v -q  luksFormat /dev/sdd1 /root/keyfile
cryptsetup luksOpen /dev/sdd1 osd1 --key-file /root/keyfile
mkfs.xfs /dev/mapper/osd1

echo "osd0	/dev/sdc1	/root/keyfile	luks" >> /etc/crypttab
echo "osd1	/dev/sdd1	/root/keyfile	luks" >> /etc/crypttab
#echo "journal0	/dev/sdb1	/root/keyfile	luks" >> /etc/crypttab
#echo "journal1	/dev/sdb2	/root/keyfile	luks" >> /etc/crypttab

mkdir -p /var/local/osd0
mkdir -p /var/local/osd1
echo "/dev/mapper/osd0	/var/local/osd0	xfs	defaults	0 0" >> /etc/fstab
echo "/dev/mapper/osd1	/var/local/osd1	xfs	defaults	0 0" >> /etc/fstab

mount /var/local/osd0
mount /var/local/osd1
