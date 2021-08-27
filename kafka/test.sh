#!/bin/bash
PROJECT=$(gcloud config list --format="value(core.project)" 2>/dev/null)

if [ ! "$1" ] || [ ! "$2" ]; then
    echo -e "Enter [consumer|producer] as first argument,
enter the topic to attach as second argument, and an optional project:
\tEx.
\t./test.sh consumer synth-topic <server>"
    exit 1;
fi

DATE=$(date +%d%H%m)
if [ "$1" == "consumer" ]; then
    TYPE="bootstrap-server"
else
    TYPE="broker-list"
fi

if [ $3 ]; then
    SERVER="$3"
else
    SERVER="$PROJECT"
fi

EXTRA="$4"

echo "Get kube creds..."
gcloud container clusters get-credentials --project="${PROJECT}" \
    --zone="australia-southeast1-a" "${PROJECT}-gke"

echo "Testing kafka $1..."
echo "Connecting to: ${SERVER}-kafka.lab.kasna.internal:9094..."
echo "Attaching to topic $2..."

kubectl run kafka-test-"$1"-"$DATE" -ti --image=strimzi/kafka:latest-kafka-2.3.0 \
    --rm=true \
    --restart=Never \
    -n kafka \
    -- \
    bin/kafka-console-"$1".sh \
    --"$TYPE" "${SERVER}"-kafka.lab.kasna.internal:9094 \
    --topic "$2" \
    "$EXTRA" \
    --property print.key=true \
    --property key.separator=":" 
