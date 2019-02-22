/usr/local/bin/vagrant:
	brew cask install vagrant
	vagrant plugin install vagrant-disksize --local

/usr/local/bin/VBoxManage:
	brew cask install virtualbox

.vagrant/machines/devenv/virtualbox/id: /usr/local/bin/vagrant /usr/local/bin/VBoxManage
	/usr/local/bin/vagrant up devenv

/usr/local/bin/python2:
	brew install python@2

/usr/local/bin/virtualenv: /usr/local/bin/python2
	/usr/local/bin/pip2 install virtualenv

.venv_devenv: /usr/local/bin/virtualenv
	/usr/local/bin/virtualenv -p /usr/local/bin/python2 .venv_devenv

.venv_devenv/bin/ansible: .venv_devenv
	.venv_devenv/bin/pip install ansible
	hash -r

.dep: .venv_devenv/bin/ansible role_requirements.yml
	.venv_devenv/bin/ansible-galaxy install -r role_requirements.yml
	touch .dep

dep: .dep


DEVENV_SSH_PRIVATE_KEY = ~/.ssh/id_rsa
.PHONY: ssh-add
ssh-add:
	ssh-add -K $(DEVENV_SSH_PRIVATE_KEY)

.PHONY: provision
provision: .vagrant/machines/devenv/virtualbox/id dep ssh-add
	.venv_devenv/bin/ansible-playbook provision/main.yml -i inventory/hosts

.PHONY: start
start:
	/usr/local/bin/vagrant up devenv

.PHONY: stop
stop:
	/usr/local/bin/vagrant halt devenv

.PHONY: restart
restart:
	/usr/local/bin/vagrant reload devenv

.PHONY: destroy
destroy:
	/usr/local/bin/vagrant destroy -f devenv

.PHONY: ssh
ssh:
	/usr/local/bin/vagrant ssh devenv
