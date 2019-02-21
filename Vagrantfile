# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "devenv" do |devenv|
    devenv.vm.box = "ubuntu/bionic64"

    devenv.vm.provider "virtualbox" do |vb|
      vb.name = "devenv"
      vb.memory = ENV['DEVENV_MEMORY_SIZE'] || 2048
    end

    devenv.vm.synced_folder "repos/", "/home/vagrant/repos"
    config.vm.synced_folder ".", "/vagrant", disabled: true

    # Ref. http://qiita.com/betahikaru/items/d77f5891f222eba0c4fa0
    devenv.vm.network "forwarded_port", guest: 22, host: 2223, id: "ssh"

    devenv.ssh.forward_agent = true

    devenv.vm.provision "shell", inline: <<-SHELL
      # For first execution of Ansible
      ln -s /usr/bin/python3 /usr/bin/python
    SHELL
  end

end
