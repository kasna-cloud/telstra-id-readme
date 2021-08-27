# ANZ Innovation Challenge
 This repo contains participant information for the ANZ Innovation Challenge event.
 Use information in this repo to explore data and develop operational apps.

## Summary 
To use this repo locally to deploy things to your team environment. Requires:
- `docker`
- `docker-compose`
- `make`
Run `make` to see what you can do.

### Shared Resources
- Transaction topic: ```anz-cde-ic-ss-kafka.lab.kasna.internal:9094, synth-topic``` 
- Payment topic: ```anz-cde-ic-ss-kafka.lab.kasna.internal:9094, payment-topic```
- Storage bucket: ```gs://anz-cde-ic-ss-storage```
- BigQuery transaction table: ```anz-cde-ic-ss.sample.transactions```
- BigQuery customers table: ```anz-cde-ic-ss.sample.customers```
- BigQuery accounts table: ```anz-cde-ic-ss.sample.accounts```

### Team Resources
- Juypterhub login: ```https://__ENVSUBST__PROJECT_ID__.lab.kasna.cloud```
- Payment Services API: ```http://__ENVSUBST__PROJECT_ID__-pspapi.lab.kasna.cloud```
- Storage: ```gs://__ENVSUBST__PROJECT_ID__-storage/```
- Git: ```gcloud source repos clone  --project=__ENVSUBST__PROJECT_ID__```
- BigQuery dataset: ```__ENVSUBST__PROJECT_ID__.team_dataset```
- Kafka for team: ```__ENVSUBST__PROJECT_ID__.lab.kasna.internal:9094```
- Airflow for team: ```https://__ENVSUBST__PROJECT_ID__-airflow.lab.kasna.cloud```
- GKE creds: 
```gcloud container clusters get-credentials --project="__ENVSUBST__PROJECT_ID__" --zone="australia-southeast1-a" "__ENVSUBST__PROJECT_ID__-gke"```

## Overview 
The ANZ Innovation Challenge for CDE and GCP is being developed so that ANZ
teams can come up with novel ways to slice and present transactional data.

This will be an internal hackathon (limited to ANZ employees in Melbourne),
run over 3 days in which teams will be able to present their work.

This repo is for ANZ IC facilitators and should communicate the technical 
environment and setup for the event. This repo should not be shared with event
participants. 

### CDE
Customer Data Ecosystem (CDE) use cases are:
1. Use a data discovery environment that will contain synthetic payments and
accounts
2. Explore the data and develop novel insights
3. Deploy steaming data to Data Factory
4. Surface ingested, streamed data into a mock mobile application

CDE represents both a "shared" or "master" project which curates and manages
access to data for a Party Data Factory (PDF). A PDF is a "team" project in the
Innovation challenge. A PDF contains data and services which are specific to 
a business stream. In the Innovation Challenge CDE data master is called
`shared services` and the Party Data Factory (PDF) is called a `team`.

The Shared Services project contains a GKE which runs a python program to 
simulate customer transactions - datasynth. This program generates batch files
of transactions and writes to a GKE hosted kafka topic to real-time transactions.

Each team project also contains a GKE and a jupyterhub service for data discovery.
These projects also contain a kafka and BigQuery service which can be written to.

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

## Resources
Additional information and resources are available at the links below:

- [Howto for JupyterLab Notebooks](https://jupyterlab.readthedocs.io/en/stable/user/notebook.html)

