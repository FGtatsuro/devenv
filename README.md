# devenv

My development environment

## Support platform

- OSX (localhost)
   - Ubuntu (workspace on GCP)
   - Ubuntu (workspace on VM)

## Requirements

- Homebrew
- Make
- Key pair for Github access
   - `~/.ssh/id_rsa`
   - `~/.ssh/id_rsa.pub`

## GCP

### Bootstrap

```bash
$ make gcp/create
...
Public IP: <external IP of GCP compute engine instance>

# ATTENTION: inventory/host_vars/devenv_gcp.yml MUST NOT be committed.
$ vi inventory/host_vars/devenv_gcp.yml
...
---
ansible_host: <external IP of GCP compute engine instance>
```

### Provision

```bash
$ make provision
```

### Start/Stop

```bash
$ make gcp/start

$ make gcp/stop

$ make gcp/restart
```

### Login

```bash
$ make gcp/ssh
```

### Update GCP resources

```bash
$ make gcp/preview
$ make gcp/update
```

### Use VPN connection

```bash
$ gcloud compute scp fujiistorage_gmail_com@devenv:~/client.ovpn .
$ open client.ovpn
```

## VM

### Setup

```bash
$ make provision DEVENV_ANSIBLE_HOST_SUBSET=devenv_vm

# With memory size(Default: 2048)
$ DEVENV_MEMORY_SIZE=4096 make provision DEVENV_ANSIBLE_HOST_SUBSET=devenv_vm
$ VBoxManage showvminfo devenv | grep 'Memory size'
Memory size                  4096MB

# With Disk size(Default: 20GB)
# FYI: https://github.com/sprotheroe/vagrant-disksize#usage
$ DEVENV_DISK_SIZE=30GB make provision DEVENV_ANSIBLE_HOST_SUBSET=devenv_vm
$ VBoxManage showmediuminfo \
  ~/VirtualBox\ VMs/devenv/ubuntu-bionic-18.04-cloudimg.vdi | \
  grep Capacity
Capacity:       30720 MBytes
```

### Start/Stop

```bash
$ make vm/start

$ make vm/stop

$ make vm/restart
```

### Login

```bash
$ make vm/ssh
```
