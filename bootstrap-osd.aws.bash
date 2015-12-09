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

apt-get update && apt-get install -y ntp ntpdate ntp-doc xfsprogs
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
apt-get remove -y apparmor

parted -s /dev/xdvb mklabel gpt
parted -s /dev/xdvb mkpart primary 0% 50%
parted -s /dev/xdvb mkpart primary 51% 100%

parted -s /dev/xdvc mklabel gpt
parted -s /dev/xdvc mkpart primary xfs 0% 100%
mkfs.xfs /dev/xdvc1

parted -s /dev/xdvd mklabel gpt
parted -s /dev/xdvd mkpart primary xfs 0% 100%
mkfs.xfs /dev/xdvd1

mkdir -p /var/local/osd0
mkdir -p /var/local/osd1
echo "/dev/xdvc1	/var/local/osd0	xfs	defaults	0 0" >> /etc/fstab
echo "/dev/xdvd1	/var/local/osd1	xfs	defaults	0 0" >> /etc/fstab
mount /var/local/osd0
mount /var/local/osd1
