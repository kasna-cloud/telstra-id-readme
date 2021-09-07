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


# TELSTRA INNOVATION DATA DATA SYNTHS

This tool will generate synthetic data for call data records (CDR) and alarm data for network servers and equipment. Each CDR and alarm is submitted to a Pub/Sub topic where it can be collected by an approrate subscription.

There are two generators that run for CDRs and one for alarming data. The are executed on a compute resource in python.

__Synthesizers__
--

__alarm-generator.py__

This synthesizer attempts to simulate alerts that are typically generated by datacenter servers and networking devices. Alerts are published to the topic 'alarm_synth' and are available in the subscription 'alarm_synth'

__australian-cdr-generator.py__

This generator will create call records to and from ten digit numbers from Australian area codes and mobiles.

__international-cdr-generator.py__
 
This generator will create call records from Country Code + Nine digits numbers, the CDR will always have and Australian (+61) number as either the call origin or destination.

__Alarm Data__
--
It is very difficult to synthesize this kind of data. This generator is only an approximation of authentic data.

The alerts are published to a topic called 'alarm_synth' and appear in the subscription called 'alarm_synth'

The format for each alert is;
```
<date>,<time>,<device name>,<alert>
```
Each generated alert is random. However the alert type will be related to the device type, eg: a server is the only device that can have a DISK type alert.

__Call Data Records__
--
Sythesized CDRs are generated and published to two topics one for Australian call records, 'aust_cdr' and one for international call records, 'intl_cdr'. 

__CDR Format__

The CDR is in a CSV format for both types of calls.

```
<date of call completion>,<time of call completion>,<origin number>,<destination number>,<status>,<length of call in seconds>
```

__Call Status__

Call status values and weights are as follows;
```
  cc = Call Collision (3%)
  nc = No Connect (2%)
  en = Engaged (4%)
  ms = Message Service (6%)
  an = Answered (85%)
```
The call status are weighted so as to give a distributed result in and attempt to simulate real data.

__Call Length__

The call length data is based on a standard deviation of 3600 (1 Hour) where the centre of the distribution is 180 seconds (3 minutes). If a random number less than 1 is selected then another number is selected.

__Call Timing__

Each CDR is sent at a random interval on anywhere between 0.1 second and 1 second 
