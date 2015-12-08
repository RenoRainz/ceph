sudo useradd -d /home/ceph -m ceph
sudo passwd cephuser
sudo echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser
sudo chmod 0440 /etc/sudoers.d/cephuser
sudo apt-get install ntp ntpdate ntp-doc
sudo /etc/init.d/apparmor stop
sudo /etc/init.d/apparmor teardown
sudo apt-get remove apparmor
