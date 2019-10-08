.PHONY: doctor
doctor:
	@if [ -z "`which gcloud`" ]; then \
		printf "\33[31m%s\33[0m\n" "gcloud doesn't exist on PATH. 👿"; \
		exit 1; \
	fi
	@printf "\33[32m%s\33[0m\n" "gcloud: OK"
	@printf "\33[32m%s\33[0m\n" "ALL OK! Let's start! 🌟"

.PHONY: api_service_account create preview update destroy
api_service_account:
	PROJECT_INFO=`gcloud projects list --format=json | \
		python -c "import json, sys; print(json.dumps([p for p in json.loads(sys.stdin.read()) if p['name'] == 'devenv'][0]))"`; \
	PROJECT_ID=`echo $$PROJECT_INFO | python -c "import json, sys; print(json.loads(sys.stdin.read())['projectId'])"`; \
	PROJECT_NUMBER=`echo $$PROJECT_INFO | python -c "import json, sys; print(json.loads(sys.stdin.read())['projectNumber'])"`; \
	SERVICE_ACCOUNT_EMAIL="serviceAccount:$$PROJECT_NUMBER@cloudservices.gserviceaccount.com"; \
	IS_SA_AS_OWNER=`gcloud projects get-iam-policy $$PROJECT_ID --format=json | \
		python -c "import json, sys; print('$$SERVICE_ACCOUNT_EMAIL' in \
		[b for b in json.loads(sys.stdin.read())['bindings'] if b['role'] == 'roles/owner'][0]['members'])"`; \
	if [ "$$IS_SA_AS_OWNER" = "False" ]; then \
		gcloud projects add-iam-policy-binding $$PROJECT_ID --member  $$SERVICE_ACCOUNT_EMAIL --role roles/owner; \
	fi

create: api_service_account
	rc=`gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -ne 0 ]; then \
		gcloud deployment-manager deployments create devenv \
		--template main.jinja \
		--automatic-rollback-on-error; \
	fi
	PUBLIC_IP=`gcloud compute instances describe devenv --format=json | \
		  python -c "import json, sys; print(json.loads(sys.stdin.read())['networkInterfaces'][0]['accessConfigs'][0]['natIP'])"`; \
		  echo "Public IP: $$PUBLIC_IP";

preview:
	rc=`gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		gcloud deployment-manager deployments update devenv \
		--template main.jinja \
		--preview; \
	fi

update:
	rc=`gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		gcloud deployment-manager deployments update devenv; \
	fi

destroy:
	rc=`gcloud deployment-manager deployments describe devenv > /dev/null 2>&1; echo $$?`; \
	if [ $$rc -eq 0 ]; then \
		gcloud deployment-manager deployments delete devenv; \
	fi

.PHONY: start stop restart
start:
	gcloud compute instances start devenv

stop:
	gcloud compute instances stop devenv

restart: stop start

.PHONY: ssh
ssh:
	gcloud compute ssh devenv --ssh-flag='-A $(EXTRA_SSH_FLAGS)'
