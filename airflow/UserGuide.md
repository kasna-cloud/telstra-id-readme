# Airflow UI Access

Every member of a team has access to a pre-created airflow instance and can log into the airflow web-ui located at https://__ENVSUBST__PROJECT_ID__-airflow.lab.kasna.cloud.

The website is authenticated by google oauth credentials and uses should login using their kasna google credentials.

![Airflow UI](images/airflow-ui.png?raw=true "Airflow UI")

# Airflow Jobs

Once users login to the web-ui there are some pre-defined sample jobs which are defined using job templates. Airflow has been pre-configured to periodically load the jobs(dags) uploaded to a google cloud storage bucket(gs://${PROJECT_ID}-storage). 
The [cloudbuild.yaml](./cloudbuild.yaml) defines a cloud build job to upload the src directory containing job definitions to the storage bucket.

![Airflow Storage](images/dags-storage.png?raw=true "Airflow Storage")

# Yaml to DAGs 

By Convention airflow jobs are written in python however to simulate CDE, we will be utilizing an existing library to dynamically create Directed acyclic graphs (DAGs) from yaml files.

For example, the yaml file below is a simple job creating two bash operator tasks, scheduled to run hourly, and with task_2 dependant on task_1.

```
1_example_dag:
  default_args:
    start_date: 2019-09-04
    timezone: 'Australia/Melbourne' 
  schedule_interval: '0 * * * *'
  description: 'this is example dag'
  tasks:
    task_1:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: 'echo 1'
    task_2:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: 'echo 2'
      dependencies: [task_1]
``

The dag.py file in the src will render dags from .yaml files in the templates directory. One can also customize timezone, schedule_interval and other airflow job options.


# Sample Jobs

These are few sample jobs to understand airflow. 

## 1_example_dag

This is a simple job with three `bash operator` tasks to demonstrate airflow as a scheduler.

template:
[JOB1](./src/templates/job1.yaml) 

1) Run the job. Click on the button as show in the image below.

![JOB1](images/job1-run.png?raw=true "JOB 1")

2) View the graph . Click on the link of the job and click on Graph View

![JOB1](images/job1.png?raw=true "JOB 1")

3) View the Task Log

Click on any node in the graph and select View Log.

## 2_bq_dataset_creation

This job utilizes the `gcloud operator` to create a BigQuery dataset and a table.

template:
[JOB2](./src/templates/job2.yaml)

1) Run the job just as in Job1

2) View the graph. Click on the link of the job and click on Graph View.

![JOB2](images/job2.png?raw=true "JOB 2")

3) View the Task Log

Click on any node in the graph and select `View Log`.

4) Check Output

After the job is successful we should be able to see a dataset and a table in BigQuery console.

![JOB2 OUTPUT](images/job2_output.png?raw=true "JOB 2 OUTPUT")

## 3_bq_examples

In this job we will utilize the above created dataset and table to explore more tasks using `gcloud operators`. we will perform four tasks in this job. 

The first task will run a sql query to query a public dataset and create a dump the data into the table we created in the earlier job. we run the sql query from a file uploaded to the cloud storage from the src/sql directory.
.
The second task will transform the BigQuery table from first task to a cloud storage bucket in avro format.

The third task will load the data from second task from cloud storage to another BigQuery table using auto schema.

The fourth task will load the data from second task from cloud storage to another BigQuery table using the schema provided loaded into the cloud storage which is uploaded from the src/schemas folder

template:
[JOB3](./src/templates/job3.yaml)

1) Run the job. Similar as Job1

2) View the graph. Click on the link of the job and click on `Graph View`.

![JOB3](images/job3.png?raw=true "JOB 3")

3) View the Task Log

Click on any node in the graph and select View Log.

4) Check Output

After the job is successful we should be able to see two additional BigQuery tables loaded from the avro data in cloud storage both with schema and auto schema modes.

![JOB3 OUTPUT](images/job3_output.png?raw=true "JOB 3 OUTPUT")
![JOB3 OUTPUT](images/job3_output2.png?raw=true "JOB 3 OUTPUT")



## 4_dataflow_job_kubernetes

Airflow GCP operators provide different ways to orchestrate within GCP. Sometimes, however,  an operator cannot meet all of the workflow requirements using just these operators. For example, the java operator does not load java classes that rely on reflection for injection. Is there some other way where all dependencies can be resolved? The `KubernetesPodOperator` can be used in place of the java operator. The GKE Pod Operator runs a pod within your GKE cluster to extend execute the needed java classes.

Before we can run this job we must build the dataflow job from the `dataflow` directory. This will create a container image with the dataflow job artifacts. Run the root directory of this repo, run the commands:
```
make auth
make install
> kafka2avro
``

Once completed, return to the airflow UI.

template:
[JOB4](./src/templates/job4.yaml)

1) Run the job. Similar as Job1

2) View the graph . Click on the link of the job and click on Graph View

![JOB4](images/job4.png?raw=true "JOB 4")

3) View the Task Log

Click on any node in the graph and select View Log

4) Check Output
After the job is submitted we should be able to see the pod task in GKE and the dataflow job created by the pod.

![JOB4 OUTPUT](images/job4_output.png?raw=true "JOB 4 OUTPUT")
![JOB4 OUTPUT](images/job4_output2.png?raw=true "JOB 4 OUTPUT")


## 5_dataflow_job_dlp

In this DAG we will be using airflow dataflow operator to create a dataflow template job https://cloud.google.com/dataflow/docs/guides/templates/provided-streaming#dlptexttobigquerystreaming. Which will create a streaming job to tokenize sensitive data with a predefined dlp template from admin repo and add the tokenized data to biqquery

template:
[JOB4](./src/templates/job4.yaml)

Before we can run this job check the following parameters in yaml:
```
        inputFilePattern: Storage bucket dataflow polls for csv files with sensitive data
        dlpProjectId: project id for dlp api can be same project
        deidentifyTemplateName: template id for dlp deidentification
        datasetName: existing bigquery dataset to create tables
```

1) Run the job. Similar as Job1

2) View the graph . Click on the link of the job and click on Graph View

![JOB4](images/job5.png?raw=true "JOB 5")

3) View the Task Log

Click on any node in the graph and select View Log

4) Check Output
After the job is submitted we should be able to see the dataflow job
This is streaming job which will poll for new files in the cloud storage. so it needs to be terminated when no longer needed.

![JOB5 OUTPUT](images/job5_output.png?raw=true "JOB 5 OUTPUT")


















