# devenv

My development environment

## Support platform

- OSX (localhost)
   - Ubuntu (workspace on VM)

## Requirements

- Homebrew
- Make
- Key pair for Github access
   - `~/.ssh/id_rsa`
   - `~/.ssh/id_rsa.pub`

## Setup

```bash
$ make provision

# With memory size(Default: 2048)
$ DEVENV_MEMORY_SIZE=4096 make provision
$ VBoxManage showvminfo devenv | grep 'Memory size'
Memory size                  4096MB

# With Disk size(Default: 20GB)
# FYI: https://github.com/sprotheroe/vagrant-disksize#usage
$ DEVENV_DISK_SIZE=30GB make provision
$ VBoxManage showmediuminfo \
  ~/VirtualBox\ VMs/devenv/ubuntu-bionic-18.04-cloudimg.vdi | \
  grep Capacity
Capacity:       30720 MBytes
```

## Start/Stop

```bash
$ make start

$ make stop

$ make restart
```

## Login

```bash
$ make ssh
```
