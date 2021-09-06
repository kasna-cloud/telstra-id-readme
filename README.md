# Telstra Innovation Challenge
 This repo contains participant information for the Telstra Innovation Challenge event.
 Use information in this repo to explore data and develop operational apps.

## Summary 
To use this repo locally to deploy things to your team environment. Requires:
- `docker`
- `docker-compose`
- `make`
Run `make` to see what you can do.

### Shared Resources
- Google Cloud Pub/Sub https://gitlab.mantelgroup.com.au/kasna/customers/telstra-id/telstra-id-data-synth
- Transaction topic: ```telstra-cde-ic-ss-kafka.lab.kasna.internal:9094, synth-topic``` 
- Payment topic: ```telstra-cde-ic-ss-kafka.lab.kasna.internal:9094, payment-topic```
- Storage bucket: ```gs://telstra-cde-ic-ss-storage```
- BigQuery transaction table: ```telstra-cde-ic-ss.sample.transactions```
- BigQuery customers table: ```telstra-cde-ic-ss.sample.customers```
- BigQuery accounts table: ```telstra-cde-ic-ss.sample.accounts```

### Team Resources
- Juypterhub login: https://18779d6207599860-dot-us-central1.notebooks.googleusercontent.com/?authuser=0
- Storage: ```gs://__ENVSUBST__PROJECT_ID__-storage/```
- Git: ```gcloud source repos clone  --project=__ENVSUBST__PROJECT_ID__```
- BigQuery dataset: ```__ENVSUBST__PROJECT_ID__.team_dataset```
- Kafka for team: ```__ENVSUBST__PROJECT_ID__.lab.kasna.internal:9094```
- Airflow for team: ```https://__ENVSUBST__PROJECT_ID__-airflow.lab.kasna.cloud```
- GKE creds: 
```gcloud container clusters get-credentials --project="__ENVSUBST__PROJECT_ID__" --zone="australia-southeast1-a" "__ENVSUBST__PROJECT_ID__-gke"```

## Overview 
The Telstra Innovation Challenge has been developed so that Telstra
teams can come up with novel ways to slice and present transactional data.

This will be an internal hackathon (limited to Telstra employees in Melbourne),
run over 1 day in which teams will be able to present their work.

This repo is for Telstra facilitators and should communicate the technical 
environment and setup for the event. This repo should not be shared with event
participants. 

An operations project will provide a python program for datasynthezing.

Each team project will contain a GKE and a jupyterhub service for data discovery.

## Design
Design documents can be found in /docs. Each directory should be considered a 
component of the system.

A brief description of each component of this repo is below:
*
## Layout 
* `airflow` Apache airflow component which can be used to schedule and manage data processing jobs 
* `dataflow` Transforms and sinks for kafka
* `notebooks` Jupyter notebooks for data exploration and examples 
* `sample_app` Sample python app which can be deployed to GKE. This app connects to BigQuery or CloudSQL and renders a custerom.
* `pipelines` CI and CD pipelines for team projects using cloudbuild

# Cloud Run Boilerplates

The Development Tech Domain also offers simple one-click deployments for hosting applications on managed Cloud Run.

|Framework|Description|Deploy|
|---|---|---|
|[React.js](boilerplate-react)|React Sample|[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/gcloudan/boilerplates-cloudrun.git&dir=boilerplate-react)|
|[Sapper.js](boilerplate-sapper)|Sapper Sample|[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/gcloudan/boilerplates-cloudrun.git&dir=boilerplate-sapper)|
|[Svelte Kit](boilerplate-sveltekit)|Sveltekit with TailwindCSS|[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/gcloudan/boilerplates-cloudrun.git&dir=boilerplate-sveltekit)|
|[Nuxt.js](boilerplate-nuxt)|Nuxt.js with TailwindCSS and TypeScript|[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/gcloudan/boilerplates-cloudrun.git&dir=boilerplate-nuxt)|
|[Next.js](boilerplate-next)|Next.js with TailwindCSS|[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run/?git_repo=https://github.com/gcloudan/boilerplates-cloudrun.git&dir=boilerplate-next)|

## Resources
Additional information and resources are available at the links below:

- [Howto for JupyterLab Notebooks](https://jupyterlab.readthedocs.io/en/stable/user/notebook.html)

