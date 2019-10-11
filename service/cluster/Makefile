CLUSTER_NAME := devenv-cluster

.PHONY: create preview update destroy config
create:
	if [ -z "`gcloud container clusters list | grep $(CLUSTER_NAME)`" ]; then \
		gcloud deployment-manager deployments create $(CLUSTER_NAME) --template main.jinja --automatic-rollback-on-error && \
		gcloud container clusters get-credentials $(CLUSTER_NAME); \
	fi

preview:
	if [ -n "`gcloud container clusters list | grep $(CLUSTER_NAME)`" ]; then \
		gcloud deployment-manager deployments update $(CLUSTER_NAME) --template main.jinja --preview; \
	fi

update:
	if [ -n "`gcloud container clusters list | grep $(CLUSTER_NAME)`" ]; then \
		gcloud deployment-manager deployments update $(CLUSTER_NAME); \
	fi

destroy:
	if [ -n "`gcloud container clusters list | grep $(CLUSTER_NAME)`" ]; then \
		gcloud deployment-manager deployments delete $(CLUSTER_NAME); \
	fi

config:
	gcloud container clusters get-credentials $(CLUSTER_NAME)
