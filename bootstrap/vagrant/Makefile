/usr/local/bin/vagrant:
	brew cask install vagrant

/usr/local/bin/VBoxManage:
	brew cask install virtualbox

.dep_plugin: /usr/local/bin/vagrant plugin_requirements.txt
	cat plugin_requirements.txt | xargs -I{} vagrant plugin install {} --local
	touch .dep_plugin


.PHONY: start
start: /usr/local/bin/vagrant /usr/local/bin/VBoxManage .dep_plugin
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
