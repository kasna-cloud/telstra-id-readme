## Dataflow
The dataflow directory contains template dataflow pipelines used to interact with Kafka, BigQuery and other GCP resources.

### Kafka2BQ
This pipeline uses the Google Dataflow templates to read off the Datasynth transaction topic and output into a BigQuery transactions table.
To run this pipeline execute the cloudbuild.yaml file using:
``
cd dataflow/kafka2bq
gcloud builds submit . --config=cloudbuild.yaml
``
The default configuration for the pipeline using the following parameters:
- Kafka broker: 'anz-cde-ic-ss-kafka.lab.kasna.internal:9094'
- Kafka Topic: 'synth-topic'
- BigQuery dataset: 'team_dataset' 
- BigQuery table:  'transactions'

### Kafka2Avro
This pipeline will pull transactions from the datasynth transation topic and output to Google Cloud Storage bucket in avro format.
There are 2 steps to execute the cloud build. The cloudbuild-compile.yam will create a scala-sbt image, compile, test and pack the 
files which can then be run.
```
cd dataflow/kafka2avro
gcloud builds submit . --config=cloudbuild.yaml
```
By default this pipeline will pull off of the shared services kafka synth-topic broker and will output to the team storage location.
To change any of the parameters used in the pipeline, change the configuration found in kafka2avro/src/main/resoures/application.conf
and re-run the compile and run.

