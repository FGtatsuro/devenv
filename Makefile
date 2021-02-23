/usr/local/bin/python3:
	brew install python

.venv_devenv: /usr/local/bin/python3
	/usr/local/bin/python3 -m venv .venv_devenv

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

DEVENV_ANSIBLE_HOST_SUBSET = devenv_gcp
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

.PHONY: gcp/doctor
gcp/doctor:
	make -C bootstrap/gcp doctor

.PHONY: gcp/create gcp/preview gcp/update gcp/destroy
gcp/create:
	make -C bootstrap/gcp create

gcp/preview:
	make -C bootstrap/gcp preview

gcp/update:
	make -C bootstrap/gcp update

gcp/destroy:
	make -C bootstrap/gcp destroy

.PHONY: gcp/start gcp/stop gcp/restart
gcp/start:
	make -C bootstrap/gcp start

gcp/stop:
	make -C bootstrap/gcp stop

gcp/restart:
	make -C bootstrap/gcp restart

.PHONY: gcp/ssh
gcp/ssh: ssh-add
	make -C bootstrap/gcp ssh

.PHONY: gcp/openvpn/create_user
gcp/openvpn/create_user:
	.venv_devenv/bin/ansible-playbook \
		operation/openvpn_create_newuser.yml \
		-i inventory/hosts \
		-l devenv_gcp

.PHONY: cluster
cluster:
	@(make -C service/cluster `cat service/cluster/Makefile | egrep '^[-_/0-9a-zA-Z]+:' | sed s/:.*$$//g | peco`)
