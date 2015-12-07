# -*- mode: ruby -*-
# vi: set ft=ruby :

# Defaults for config options defined in CONFIG
$num_osd = 3
$osd_gui = false
$osd_memory = 1024
$osd_cpus = 1

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = " ubuntu/trusty64"

  # Master definition
  config.vm.define :admin do |admin|
      admin.vm.hostname = "ceph-admin"
      admin.vm.network :private_network, ip: "172.16.1.100", virtualbox__intnet: "pxc_network"

      admin.vm.provider :virtualbox do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      # Setup of /etc/hosts of salt master
      (1..num_osd).each do |j|
        admin.vm.provision :hosts do |provisioner|
            provisioner.add_host '172.16.0.100', ['ceph-admin.internal', 'ceph-admin']
            provisioner.add_host "172.16.0.#{j+110}", ["ceph-osd-#{j}.internal", "ceph-osd-#{j}"]
        end
      end
  end

  # OSD node definition
  (1..num_osd).each do |i|

     config.vm.define "ceph-osd-#{i}" do |ceph-osd|
         ceph-osd.vm.hostname = "ceph-osd-#{i}"
         ceph-osd.vm.network :private_network, ip: "172.16.0.#{i+100}", virtualbox__intnet: "pxc_network"
         ceph-osd.vm.network :private_network, virtualbox__intnet: "pxc_network"

         ceph-osd.vm.provider :virtualbox do |vb|
           vb.memory = osd_memory
           vb.cpus = osd_cpus
         end

         # /etc/hosts configuration
         ceph-osd.vm.provision :hosts do |provisioner|
           provisioner.add_host '172.16.0.100', ['ceph-admin.internal', 'ceph-admin']
           provisioner.add_host "172.16.0.#{i+110}", ["ceph-osd-#{i}.internal", "ceph-osd-#{i}"]
         end



     end
  end

end
