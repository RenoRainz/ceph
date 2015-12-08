#/bin/bash
useradd -d /home/ceph -m ceph
echo "ceph:ceph" | chpasswd
echo "cephuser ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/cephuser
chmod 0440 /etc/sudoers.d/cephuser

apt-get install ntp ntpdate ntp-doc
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
apt-get remove apparmor

parted -s /dev/sdb mklabel gpt
parted -s /dev/sdb mkpart primary 0% 50%
parted -s /dev/sdb mkpart primary 51% 100%
parted -s /dev/sdc mklabel gpt
parted -s /dev/sdc mkpart primary xfs 0% 100%
parted -s /dev/sdd mklabel gpt
parted -s /dev/sdd mkpart primary xfs 0% 100%
