# Sample Application

This folder has a sample application with a server side api and a client side frondend deployed into gke environment of the team

# Server Side Spec

Python Flask application

Postgres db using CloudSQL via cloudsql proxy

GKE Deployment running unicorn app to expose flask api

# Client Side Spec

Vue Js application

GKE deployment with nginx 

# Deployment Steps

To Deploy we first need to create a postgres db and set some initial configuration such as create db, setting kubernetes secret in the namespace for cloudsql proxy and setting db username, password in kubernetes as secrets

Please set the enviroment variables:

```
PROJECT_ID -> project id of your gcp 
HOST_PROJECT_NAME -> project id of your gcp host project to create cloudsql in sharedvpc
NETWORK_NAME -> Shared VPC name of your host project
POSTGRES_PASSWORD -> postgress password to use to connect to db
```

Run the following script to create the db and secrets in kubernetes


```cloudsql.sh```


After the postgres db is created. We will need to seed data into the database for our api to expose

running the following cloudbuild step will create migration job in kubernetes to seed data into postgres

```gcloud builds submit . --config=cloudbuild-db-migration.yaml```

Then we can deploy the api & frontend into gke using the following step 

```gcloud builds submit . --config=cloudbuild.yaml```