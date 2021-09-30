#!/bin/bash
export PROJECT_ID=$(gcloud config get-value project)
docker build -t datasynth .
docker tag datasynth gcr.io/$PROJECT_ID/datasynth
docker push gcr.io/$PROJECT_ID/datasynth

export TF_VAR_project_id=$PROJECT_ID
cd terraform
terraform init
terraform apply --auto-approve