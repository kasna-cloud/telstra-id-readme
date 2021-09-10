# Telstra Innovation Challenge
 This repo contains participant information for the Telstra Innovation Challenge event.
 Use information in this repo to explore data and develop operational apps.

## Summary 
To use this repo locally to deploy things to your team environment. Requires:
- `make`
Run `make` to see what you can do.

### Shared Resources
- [Google Cloud Pub/Sub](telstra-id-data-synth)
- Storage bucket: ```gs://telstra-id-storage```
- Storage bucket: ```https://source.cloud.google.com/telstra-id/shared-resources```

### Team Resources
- Juypterhub login: ```make notebook```
- Storage: ```gs://telstra-id-PROJECT_ID-storage/```
- Git: ```gcloud source repos clone  --project=telstra-id-PROJECT_ID```
- GKE creds: 
```gcloud container clusters get-credentials --project=telstra-id-PROJECT_ID --zone="australia-southeast1-a" "telstra-id-PROJECT_ID-gke"```

## Overview 
The Telstra Innovation Challenge has been developed so that Telstra
teams can come up with novel ways to slice and present transactional data.

This will be an internal hackathon (limited to Telstra employees in Melbourne),
run over 1 day in which teams will be able to present their work.

An operations project will provide shared services and a data synthesizer.

Each team project will contain a GKE and a JupyterHub service for data discovery.

## Design
Design documents can be found in. Each directory should be considered a 
component of the system.

A brief description of each component of this repo is below:
*
## Layout 
* `notebooks` Jupyter notebooks for data exploration and examples 
* `sample_app` Sample backend python app which can be deployed to GKE.
## Cloud Run Boilerplates

These are available as a simple one-click deployment for hosting applications on managed Cloud Run.

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