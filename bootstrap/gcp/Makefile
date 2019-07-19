/usr/local/bin/gcloud:
	brew cask install google-cloud-sdk

.PHONY: deploy start stop restart destroy ssh

create: /usr/local/bin/gcloud
	rc=`/usr/local/bin/gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -ne 0 ]; then \
		/usr/local/bin/gcloud deployment-manager deployments create devenv \
		--template main.jinja \
		--automatic-rollback-on-error; \
	fi

start: /usr/local/bin/gcloud
	/usr/local/bin/gcloud compute instances start devenv

stop: /usr/local/bin/gcloud
	/usr/local/bin/gcloud compute instances stop devenv

restart: /usr/local/bin/gcloud stop start

destroy: /usr/local/bin/gcloud
	rc=`/usr/local/bin/gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		/usr/local/bin/gcloud deployment-manager deployments delete devenv; \
	fi

ssh: /usr/local/bin/gcloud
	/usr/local/bin/gcloud compute ssh devenv --ssh-flag='-A'
