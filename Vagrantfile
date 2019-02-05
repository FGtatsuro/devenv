# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "devenv" do |devenv|
    devenv.vm.box = "ubuntu/bionic64"

    devenv.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end

    devenv.vm.provision "shell", inline: <<-SHELL
      apt-get update
    SHELL
  end

end
