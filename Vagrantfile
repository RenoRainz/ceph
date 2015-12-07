# -*- mode: ruby -*-
# vi: set ft=ruby :

# Defaults for config options defined in CONFIG
$num_osd = 3
$vb_gui = false
$vb_memory = 1024
$vb_cpus = 1

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
      master.vm.hostname = "ceph-admin"
      master.vm.network :private_network, ip: "172.16.1.100", virtualbox__intnet: "pxc_network"

      master.vm.provider :virtualbox do |vb|
          vb.memory = 1024
          vb.cpus = 1
  end


end
