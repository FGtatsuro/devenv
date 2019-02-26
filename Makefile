/usr/local/bin/vagrant:
	brew cask install vagrant

/usr/local/bin/VBoxManage:
	brew cask install virtualbox

/usr/local/bin/python2:
	brew install python@2

/usr/local/bin/virtualenv: /usr/local/bin/python2
	/usr/local/bin/pip2 install virtualenv

.venv_devenv: /usr/local/bin/virtualenv
	/usr/local/bin/virtualenv -p /usr/local/bin/python2 .venv_devenv

.venv_devenv/bin/ansible: .venv_devenv
	.venv_devenv/bin/pip install ansible
	hash -r

.dep_role: .venv_devenv/bin/ansible role_requirements.yml
	.venv_devenv/bin/ansible-galaxy install -r role_requirements.yml
	touch .dep_role

.dep_plugin: /usr/local/bin/vagrant plugin_requirements.txt
	cat plugin_requirements.txt | xargs -I{} vagrant plugin install {} --local
	touch .dep_plugin

dep: .dep_role .dep_plugin


DEVENV_SSH_PRIVATE_KEY = ~/.ssh/id_rsa
.PHONY: ssh-add
ssh-add:
	ssh-add $(DEVENV_SSH_PRIVATE_KEY)

.vagrant/machines/devenv/virtualbox/id: /usr/local/bin/vagrant /usr/local/bin/VBoxManage .dep_plugin
	/usr/local/bin/vagrant up devenv


DEVENV_ANSIBLE_HOST_SUBNET = devenv
.PHONY: provision
provision: .vagrant/machines/devenv/virtualbox/id dep ssh-add
	.venv_devenv/bin/ansible-playbook provision/main.yml -i inventory/hosts -l $(DEVENV_ANSIBLE_HOST_SUBNET)

.PHONY: start
start: ssh-add
	/usr/local/bin/vagrant up devenv

.PHONY: stop
stop:
	/usr/local/bin/vagrant halt devenv

.PHONY: restart
restart: ssh-add
	/usr/local/bin/vagrant reload devenv

.PHONY: destroy
destroy:
	/usr/local/bin/vagrant destroy -f devenv

.PHONY: ssh
ssh:
	/usr/local/bin/vagrant ssh devenv
