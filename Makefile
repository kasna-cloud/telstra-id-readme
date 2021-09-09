# use some sensible default shell settings
SHELL := /bin/bash -o pipefail
.SILENT:
.DEFAULT_GOAL := help

# gcp configuration
GCP_ADMIN_PROJECT = telstra-demo-324023
GCP_SS_PROJECT = telstra-demo-324023

##@ Local
.PHONY: auth
auth: ## Authenticate with gcloud
	echo "Authenticating with gcloud..."
	gcloud auth login
	@read -p "Enter your team's Project ID (telstra-demo-324023): " project; \
	gcloud config set project $$project

.PHONY: notebook 
notebook: ## Deploy software components
	gcloud notebooks instances create telstra-ai \
  --vm-image-project=deeplearning-platform-release \
  --vm-image-family=tf2-2-3-cpu \
  --machine-type=n1-standard-4 --location=australia-southeast1-b

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
