# -*- mode: ruby -*-
# vi: set ft=ruby :

# Defaults for config options defined in CONFIG


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
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false
  num_osd = 3
  disk_by_osd = 3
  osd_disk_size = 8
  osd_gui = false
  osd_memory = 1024
  osd_cpus = 1

  # Ceph admin definition
  config.vm.define "ceph-admin" do |admin|
      admin.vm.hostname = "ceph-admin"
      admin.vm.network :private_network, ip: "172.16.1.100", virtualbox__intnet: "front_network"

      admin.vm.provider :virtualbox do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      # Bootstrapping
      config.vm.provision :shell, path: "bootstrap-ceph-admin.bash"

  end

  # Ceph client definition
  config.vm.define "ceph-client" do |admin|
      admin.vm.hostname = "ceph-client"
      admin.vm.network :private_network, ip: "172.16.1.101", virtualbox__intnet: "front_network"

      admin.vm.provider :virtualbox do |vb|
        vb.memory = 512
        vb.cpus = 1
      end

      # Bootstrapping
      #config.vm.provision :shell, path: "bootstrap-ceph-admin.bash"

  end

  # OSD node definition
  (1..num_osd).each do |i|

     config.vm.define "ceph-osd-#{i}" do |osd|
         osd.vm.hostname = "ceph-osd-#{i}"
         osd.vm.network :private_network, ip: "172.16.1.#{i+110}", virtualbox__intnet: "front_network"
         osd.vm.network :private_network, ip: "172.16.2.#{i+110}", virtualbox__intnet: "storage_network"

         osd.vm.provider :virtualbox do |vb|
           vb.memory = osd_memory
           vb.cpus = osd_cpus
         end

         # Add OSD disks
         (1..disk_by_osd).each do |d|
           file_to_disk = "/home/renaud/VirtualBox VMs/ceph-osd-#{i}/osd-#{d}.vmdk"
           config.vm.provider "virtualbox" do | vb |
              unless File.exist?(file_to_disk)
                vb.customize ['createhd', '--filename', file_to_disk, '--size', osd_disk_size * 1024]
              end
             vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', "#{d}", '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
           end
         end

         # /etc/hosts configuration
         osd.vm.provision :hosts do |provisioner|
           provisioner.add_host '172.16.1.100', ['ceph-admin.internal', 'ceph-admin']
           provisioner.add_host "172.16.1.#{i+110}", ["ceph-osd-#{i}.internal", "ceph-osd-#{i}"]
         end

         # Bootstrapping
         config.vm.provision :shell, path: "bootstrap.bash"

     end
  end

end
