
#!/bin/bash

#Create Namespace
kubectl apply -f files/ns.yaml


#Create cloudsql and secrets
gcloud beta sql instances create "${PROJECT_ID}-postgres" --database-version=POSTGRES_9_6 --cpu=2 --memory=7680MiB --network="projects/${HOST_PROJECT_NAME}/global/networks/${NETWORK_NAME}" --no-assign-ip --project=${PROJECT_ID} --region=australia-southeast1

gcloud sql users set-password postgres --instance="${PROJECT_ID}-postgres" --password="${POSTGRES_PASSWORD}" --project=${PROJECT_ID}

kubectl create secret generic cloudsql-db-credentials --from-literal=username="postgres" --from-literal=password="${POSTGRES_PASSWORD}" -n app

gcloud beta iam service-accounts create postgres-user --project=${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:postgres-user@${PROJECT_ID}.iam.gserviceaccount.com --role roles/cloudsql.client

gcloud iam service-accounts keys create ./private/postgres.json --iam-account postgres-user@${PROJECT_ID}.iam.gserviceaccount.com --project=${PROJECT_ID}

kubectl create secret generic cloudsql-instance-credentials -n app --from-file=credentials.json=./private/postgres.json -n app

gcloud sql databases create sample --instance="${PROJECT_ID}-postgres" --project=${PROJECT_ID}

