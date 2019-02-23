# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

VM_INFO_FILE = ".vm_info.yml"

Vagrant.configure("2") do |config|

  config.vm.define "devenv" do |devenv|
    devenv.vm.box = "ubuntu/bionic64"

    if File.exist?(VM_INFO_FILE)
      vm_info = YAML.load_file(VM_INFO_FILE)
      memory_size = vm_info["memory_size"]
      disk_size = vm_info["disk_size"]
    else
      memory_size = ENV["DEVENV_MEMORY_SIZE"].to_i || 2048
      disk_size = ENV["DEVENV_DISK_SIZE"] || "20GB"
    end

    devenv.vm.provider "virtualbox" do |vb|
      vb.name = "devenv"
      vb.memory = memory_size
    end
    devenv.disksize.size = disk_size

    devenv.vm.synced_folder "repos/", "/home/vagrant/repos"

    # Ref. http://qiita.com/betahikaru/items/d77f5891f222eba0c4fa0
    devenv.vm.network "forwarded_port", guest: 22, host: 2223, id: "ssh"

    devenv.ssh.forward_agent = true

    devenv.vm.provision "shell", inline: <<-SHELL
      # For first execution of Ansible
      if [ ! -e /usr/bin/python ]; then
        ln -s /usr/bin/python3 /usr/bin/python
      fi
    SHELL

    # Ref. https://www.vagrantup.com/docs/triggers/usage.html
    devenv.trigger.after :up do |trigger|
      trigger.ruby do
        File.open(VM_INFO_FILE, "w") do |f|
          YAML.dump({"memory_size" => memory_size, "disk_size" => disk_size}, f)
        end
      end
    end
  end

end
