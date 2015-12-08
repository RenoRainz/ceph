#/bin/bash

useradd -d /home/ceph -m ceph
echo "ceph:ceph" | chpasswd
echo "ceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph

apt-get install -y ntp ntpdate ntp-doc xfsprogs
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
apt-get remove -y apparmor

parted -s /dev/sdb mklabel gpt
parted -s /dev/sdb mkpart primary 0% 50%
parted -s /dev/sdb mkpart primary 51% 100%

parted -s /dev/sdc mklabel gpt
parted -s /dev/sdc mkpart primary xfs 0% 100%
mkfs.xfs /dev/sdc1

parted -s /dev/sdd mklabel gpt
parted -s /dev/sdd mkpart primary xfs 0% 100%
mkfs.xfs /dev/sdd1
