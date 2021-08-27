# Airflow

This section provides different airflow dag creation using yaml job templates for gcp

src/schemas folder is used to store any bigquery schemas as .json files

src/sql folder is used to store any bigquery sql scripts as .sql files

src/templates folder is used to store any airflow dags as .yaml files

    src/templates/job1.yaml : A simple airflow job to create multiple tasks generated as a dag job in airflow through yaml file

    src/templates/job2.yaml : An airflow job to create bigquery dataset and table with gcp operators

    src/templates/job3.yaml : An airflow job to demonstrate different bigquery and gcp operations using operators

    src/templates/job4.yaml : An airflow job to demonstrate a scio based dataflow job created using a GKEPodOperator

    src/templates/job5.yaml : An airflow job to demonstraate Dataflow Template Job to tokenize sensitive date using google cloud Data Loss Protection

