#/bin/bash


# User creation
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

# Software installation
echo "boostrap : package installation"
export http_proxy=http://10.100.1.200:3128
echo "http_proxy=http://10.100.1.200:3128" >> /etc/environment
touch /etc/apt/apt.conf
echo 'Acquire::http::Proxy "http://10.100.1.200:3128";' >/etc/apt/apt.conf
wget -q -O- 'https://git.ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
apt-add-repository 'deb http://download.ceph.com/debian-hammer/ trusty main'
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-trusty main'
apt-get update && apt-get install -y ntp ntpdate ntp-doc xfsprogs docker-engine=1.9.1-0~trusty librados-dev=0.94.5-1trusty librbd-dev=0.94.5-1trusty golang ceph-common=0.94.5-1trusty gcc

/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown

# Building plugin
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
https_proxy=http://10.100.1.200:3128 go get github.com/yp-engineering/rbd-docker-plugin
/root/bin/rbd-docker-plugin --create --user=docker --pool=docker &

export http_proxy="http://10.100.1.200:3128" >> /etc/default/docker

# Ntp config
echo "bootstrap :ntp configuration."
echo "driftfile /var/lib/ntp/ntp.drift
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
server 10.100.1.200
restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery
restrict 127.0.0.1
restrict ::1" >/etc/ntp.conf
service ntp restart
