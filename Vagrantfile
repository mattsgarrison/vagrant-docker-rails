# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # VMware
  #config.vm.box = "precise64"
  #config.vm.box = "http://files.vagrantup.com/precise64_vmware.box"
 

  # VirtualBox
  config.vm.box = "raring64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.hostname = "rails.dev"
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  # Sharing the docker configs
  config.vm.synced_folder "./docker", "/docker"


  # vagrant up --provider=vmware_fusion
  # config.vm.provider "vmware_fusion" do |f|
  #   f.vmx["memsize"] = "512"
  #   f.vmx["numvcpus"] = "2"
  #   f.vmx["displayName"] = "v_general"
  #   f.vmx["annotation"] = "a general vagrant vm"
  # end

  config.vm.provider :virtualbox do |vb|
    # Boot with or without headless mode
    vb.gui = false
    # Use VBoxManage to customize the VM. You may have to add the VirtualBox
    # installation directory to your environment Path.
    # For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
    #puppet.options        = %w[ --libdir=\\puppet/modules/rbenv/lib ]

  end

end
