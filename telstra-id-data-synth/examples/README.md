# EXAMPLES

This directory contains some examples for reading the subscriptions for each of the topics. In order to use them you will need to set you project id to where you have deployed;
```
gcloud config set project <project-name>
```

The messages for each of the data synthersizers are published to a Pub/Sub topic and the necessary subscriptions already exist, they are;
```
cdr_intl
cdr_aust
alarm_synth
```

__Using Python__
--
The python example directory contains some sample code that will read the subscriptions and display messages. First change the project_id, topic_id and subscription_id to the values you need and then the code can be run with;
```
python3 dump-messages.py
```

__Using GO__
--
A GO example is provided in the go-example directory. You will need to set the project_id and subscription_id. Run the code with;
```
go run .
```
The results are output into a file called output.csv, this file will be appended to each run.


__Using GCLOUD__
--

It is possible to use GCLOUD to view the messages in the subscription queue. For example;

List the next 100 messages and acknowledge them
```
gcloud alpha pubsub subscriptions pull cdr_aust --auto-ack --limit 100
gcloud alpha pubsub subscriptions pull cdr_intl --auto-ack --limit 100
gcloud alpha pubsub subscriptions pull alarm_synth --auto-ack --limit 100
``'