# use some sensible default shell settings
SHELL := /bin/bash -o pipefail
.SILENT:
.DEFAULT_GOAL := help

# gcp configuration
GCP_ADMIN_PROJECT = anz-ic-admin
GCP_SS_PROJECT = anz-cde-ic-ss

# docker-compose calls
GCLOUD = docker-compose run gcloud

##@ Entry Points
.PHONY: build
build: _init ## TODO 

.PHONY: deploy 
install: ## Deploy software components
	echo -e "Enter name of component:"
	echo -e " airflow\n dataflow/kafka2avro\n dataflow/kafka2bq\n sample_app"
	@read -p " > " component; \
	$(GCLOUD) builds submit /app/$$component/. --config=/app/$$component/cloudbuild.yaml --timeout=1h

.PHONY: test
test: ## Run tests 
	$(GCLOUD) builds submit /app/tests/. --config=/app/tests/cloudbuild.yaml


##@ Local
.PHONY: auth
auth: ## Authenticate with gcloud
	echo "Authenticating with gcloud..."
	$(GCLOUD) auth login
	@read -p "Enter your team project (anz-cde-ic-team-X): " project; \
	$(GCLOUD) config set project $$project

.PHONY: shell
shell: ## Shell into gcloud container for local debugging with bash
	docker-compose run . --entrypoint=bash gcloud 

##@ Misc
.PHONY: help
help: ## Display this help
	awk \
	  'BEGIN { \
	    FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n" \
	  } /^[a-zA-Z_-]+:.*?##/ { \
	    printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	  } /^##@/ { \
	    printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	  }' $(MAKEFILE_LIST)

##@ Helpers
.PHONY: _init
_init: _clean ## Initialise TODO 

.PHONY: _clean
_clean: ## TODO 
