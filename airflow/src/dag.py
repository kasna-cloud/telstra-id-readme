from airflow import DAG
import dagfactory
import os
import glob
import logging

dir_path = os.path.dirname(os.path.realpath(__file__))
templates = glob.glob(os.path.join(dir_path,"templates/*.yaml"))
for template in templates:
    try:
        dag_factory = dagfactory.DagFactory(os.path.join(dir_path,template))
        dag_factory.generate_dags(globals())
    except Exception as e:
        logging.error("Error when generating dag from template %s", template) 
        logging.error(str(e)) 