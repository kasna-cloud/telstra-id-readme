#!/bin/bash
docker build -t datasynth .
docker tag datasynth gcr.io/telstra-id-data-synth/datasynth
docker push gcr.io/telstra-id-data-synth/datasynth

cd terraform
terrafrom init
terraform apply --auto-approve