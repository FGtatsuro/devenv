/usr/local/bin/gcloud:
	brew cask install google-cloud-sdk

.PHONY: deploy start stop restart destroy ssh

api_service_account: /usr/local/bin/gcloud
	PROJECT_INFO=`/usr/local/bin/gcloud projects list --format=json | \
		python -c "import json, sys; print(json.dumps([p for p in json.loads(sys.stdin.read()) if p['name'] == 'devenv'][0]))"`; \
	PROJECT_ID=`echo $$PROJECT_INFO | python -c "import json, sys; print(json.loads(sys.stdin.read())['projectId'])"`; \
	PROJECT_NUMBER=`echo $$PROJECT_INFO | python -c "import json, sys; print(json.loads(sys.stdin.read())['projectNumber'])"`; \
	SERVICE_ACCOUNT_EMAIL="serviceAccount:$$PROJECT_NUMBER@cloudservices.gserviceaccount.com"; \
	IS_SA_AS_OWNER=`/usr/local/bin/gcloud projects get-iam-policy $$PROJECT_ID --format=json | \
		python -c "import json, sys; print('$$SERVICE_ACCOUNT_EMAIL' in \
		[b for b in json.loads(sys.stdin.read())['bindings'] if b['role'] == 'roles/owner'][0]['members'])"`; \
	if [ "$$IS_SA_AS_OWNER" = "False" ]; then \
		/usr/local/bin/gcloud projects add-iam-policy-binding $$PROJECT_ID --member  $$SERVICE_ACCOUNT_EMAIL --role roles/owner; \
	fi

create: /usr/local/bin/gcloud api_service_account
	rc=`/usr/local/bin/gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -ne 0 ]; then \
		/usr/local/bin/gcloud deployment-manager deployments create devenv \
		--template main.jinja \
		--automatic-rollback-on-error; \
	fi
	PUBLIC_IP=`/usr/local/bin/gcloud compute instances describe devenv --format=json | \
		  python -c "import json, sys; print(json.loads(sys.stdin.read())['networkInterfaces'][0]['accessConfigs'][0]['natIP'])"`; \
		  echo "Public IP: $$PUBLIC_IP";

preview: /usr/local/bin/gcloud
	rc=`/usr/local/bin/gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		/usr/local/bin/gcloud deployment-manager deployments update devenv \
		--template main.jinja \
		--preview; \
	fi

update: /usr/local/bin/gcloud
	rc=`/usr/local/bin/gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		/usr/local/bin/gcloud deployment-manager deployments update devenv; \
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
