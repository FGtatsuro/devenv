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


DEVENV_SSH_PRIVATE_KEY = ~/.ssh/id_rsa
.PHONY: ssh-add
ssh-add:
	ssh-add $(DEVENV_SSH_PRIVATE_KEY)

DEVENV_ANSIBLE_HOST_SUBSET = devenv_vm
.PHONY: provision
provision: .dep_role ssh-add
	.venv_devenv/bin/ansible-playbook provision/main.yml -i inventory/hosts -l $(DEVENV_ANSIBLE_HOST_SUBSET)


.PHONY: vm/start vm/stop vm/restart vm/destroy vm/ssh
vm/start: ssh-add
	make -C bootstrap/vagrant start

vm/stop:
	make -C bootstrap/vagrant stop

vm/restart:
	make -C bootstrap/vagrant restart

vm/destroy:
	make -C bootstrap/vagrant destroy

vm/ssh:
	make -C bootstrap/vagrant ssh

.PHONY: gcp/create gcp/start gcp/stop gcp/restart gcp/destroy gcp/ssh
gcp/create:
	make -C bootstrap/gcp create

gcp/start:
	make -C bootstrap/gcp start

gcp/stop:
	make -C bootstrap/gcp stop

gcp/restart:
	make -C bootstrap/gcp restart

gcp/destroy:
	make -C bootstrap/gcp destroy

gcp/ssh:
	make -C bootstrap/gcp ssh
