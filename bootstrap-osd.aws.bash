#!/bin/bash

echo "boostrap : user creation"
useradd -d /home/ceph -s /bin/bash -m ceph
echo "ceph:ceph" | chpasswd
echo "ceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph

mkdir /home/ceph/.ssh
chmod 700 /home/ceph/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoc+s56EuX7DXURRCbGiezaynKRS8MRWogkSMvxF4Z6M+ebRGJTFkoGxlEGeBH5Hf+yTfM/QIywIj/v5I8Pi7QNZDE2ttIucnloyFnMHHZVTF7al/JjLqYAaerYpQ9yCuBoFjEKdE4m04mCSrg3Tsk7t6eWBniLqTdCDr4ZiuAvf4fSPHca+3Jp8p2all3Lmny/doYxDhpucv3rQ3UAx+IH07rLJU4eJSMWqwGRz0NZY1qCWByl857dP9EFMiXU1g8OtDnAZo7V107V6DCc6HVBdiGLz5Ydtrbq5B2SHxgzKTgJEmfehcZXqNeos0chf4056ocCGg1Cvk/xWfo8mlZ cephuser@ceph-admin" > /home/ceph/.ssh/authorized_keys
chmod 600 /home/ceph/.ssh/authorized_keys
echo "http_proxy=http://10.100.1.200:3128
https_proxy=http://10.100.1.200:3128" > /home/ceph/.wgetrc
echo "http_proxy=http://10.100.1.200:3128
https_proxy=http://10.100.1.200:3128" > /root/.wgetrc

chown -R ceph:ceph /home/ceph/

echo "boostrap : package installation"
export http_proxy=http://10.100.1.200:3128
echo "http_proxy=http://10.100.1.200:3128" >> /etc/environment
apt-get update && apt-get install -y ntp ntpdate ntp-doc xfsprogs
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
apt-get remove -y apparmor

echo "boostrap : disk configuration"
parted -s /dev/xvdb mklabel gpt
parted -s /dev/xvdb mkpart primary 0% 50%
parted -s /dev/xvdb mkpart primary 51% 100%

parted -s /dev/xvdc mklabel gpt
parted -s /dev/xvdc mkpart primary xfs 0% 100%
mkfs.xfs /dev/xvdc1

parted -s /dev/xvdd mklabel gpt
parted -s /dev/xvdd mkpart primary xfs 0% 100%
mkfs.xfs /dev/xvdd1

mkdir -p /var/local/osd0
mkdir -p /var/local/osd1
echo "/dev/xvdc1	/var/local/osd0	xfs	defaults	0 0" >> /etc/fstab
echo "/dev/xvdd1	/var/local/osd1	xfs	defaults	0 0" >> /etc/fstab
mount /var/local/osd0
mount /var/local/osd1

# Setting hostname
echo "boostrap : setting hostname"
ip=$(ip a s dev eth0 | grep inet | grep -v inet6  | awk '{print $2}')
case "$ip" in
  "10.200.1.11/24")
    hostname ceph-osd-1
    echo "ceph-osd-1" > /etc/hostname
    echo "auto eth1
iface eth1 inet static
address 10.200.3.11
netmask 255.255.255.0
" >/etc/network/interfaces.d/eth1.config
    ifup eth1
    ;;
  "10.200.1.12/24")
    hostname ceph-osd-2
    echo "ceph-osd-2" > /etc/hostname
    echo "auto eth1
iface eth1 inet static
address 10.200.3.12
netmask 255.255.255.0
" >/etc/network/interfaces.d/eth1.config
    ifup eth1
    ;;
  "10.200.1.13/24")
    hostname ceph-osd-3
    echo "ceph-osd-3" > /etc/hostname
    echo "auto eth1
iface eth1 inet static
address 10.200.3.13
netmask 255.255.255.0
" >/etc/network/interfaces.d/eth1.config
    ifup eth1
    ;;
esac

touch /tmp/bootstrap.done
