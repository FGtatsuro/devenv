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
```

# Login

```bash
$ make ssh
```
