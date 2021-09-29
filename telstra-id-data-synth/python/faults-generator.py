'''Generates a row of data that represents a customer online at the specified timestamp. Also generates another data stream that represents the customers service requests related to faults in their internet service.'''
from datetime import datetime
from numpy.random import uniform, normal
from google.cloud import pubsub_v1
import os
import time
import json
import pandas as pd

mean_drop_expected = 4 # average percent of customers who go offline in a non-outage situation
std_dev_drop_expected = 2 # standard deviation of percent of customers who go offline in a non-outage situation
min_drop_anomaly = 5 # min percent of customers who go offline in an outage
max_drop_anomaly = 100 # max percent of customers who go offline in an outage
min_prob_customer_submits_service_request = 0.05 # min probability a customer submits a service request related to the outage
max_prob_customer_submits_service_request = 0.20 # max probability a customer submits a service request related to the outage
prob_outage = 0.0005 # probability of an outage

data_freq = 1 # seconds per row; minimum that can be set is ~0.10
publish = True

customer_id_suburbs = pd.read_csv('./faults_customer_id_suburbs.csv')
prev_online = customer_id_suburbs
num_suburbs = customer_id_suburbs['suburb_state'].nunique()
suburb_list = list(customer_id_suburbs['suburb_state'].unique())

project_id = os.environ['PROJECT_ID']

topic_id1 = os.environ['FAULTS_CUSTOMER_MODEM_DATA_PUBSUB_TOPIC']
publisher1 = pubsub_v1.PublisherClient()
topic_path1 = publisher1.topic_path(project_id, topic_id1)

topic_id2 = os.environ['FAULTS_SERVICE_REQUESTS_PUBSUB_TOPIC']
publisher2 = pubsub_v1.PublisherClient()
topic_path2 = publisher2.topic_path(project_id, topic_id2)

while True:
    # for the current timestamp, produce a row of data for each online customer
    current_time = datetime.now()
    
    # randomly choose suburbs in an outage
    outages = uniform(0, 1, size=num_suburbs) <= prob_outage
    outages_df = pd.DataFrame({'suburb_state': suburb_list, 'outage': outages})
    
    # suburbs not in an outage
    non_outages_suburb_list = outages_df[outages_df['outage']==False]['suburb_state'].tolist()
    non_outages_num_suburbs = len(non_outages_suburb_list)
    non_outages_prob_sample_per_suburb = normal((1-(mean_drop_expected/100)), std_dev_drop_expected/100, size=non_outages_num_suburbs)
    non_outages_prob_sample_per_suburb = [i if i < 1 else 1 for i in non_outages_prob_sample_per_suburb]
    non_outages_samples_per_suburb_dict = dict(zip(non_outages_suburb_list, non_outages_prob_sample_per_suburb))
    non_outages_prev_online = prev_online[prev_online['suburb_state'].isin(non_outages_suburb_list)]
    non_outages_online_customers = non_outages_prev_online.groupby(['suburb_state'])['customer_id'].apply(lambda group: group.sample(frac=non_outages_samples_per_suburb_dict[group.name])).reset_index().drop('level_1', axis=1)
    
    # suburbs in an outage
    if outages.sum() > 0:
        outages_suburb_list = outages_df[outages_df['outage']==True]['suburb_state'].tolist()
        outages_num_suburbs = len(outages_suburb_list)
        outages_prob_sample_per_suburb = uniform((100-max_drop_anomaly)/100, (100-min_drop_anomaly)/100, size=outages_num_suburbs)
        outages_samples_per_suburb_dict = dict(zip(outages_suburb_list, outages_prob_sample_per_suburb))
        outages_prev_online = prev_online[prev_online['suburb_state'].isin(outages_suburb_list)]
        outages_online_customers = outages_prev_online.groupby(['suburb_state'])['customer_id'].apply(lambda group: group.sample(frac=outages_samples_per_suburb_dict[group.name])).reset_index().drop('level_1', axis=1)
        output1 = pd.concat([outages_online_customers, non_outages_online_customers])
        output1['timestamp'] = current_time
        
        # service requests dataset
        outages_impacted_customers = outages_prev_online[~outages_prev_online['customer_id'].isin(outages_online_customers['customer_id'].unique())]
        prop_service_request = uniform(min_prob_customer_submits_service_request, \
                                       max_prob_customer_submits_service_request)
        outages_service_requests = outages_impacted_customers.sample(frac=prop_service_request)[['customer_id', 'suburb_state']]
        outages_service_requests['timestamp'] = current_time
        output2 = outages_service_requests[['customer_id', 'timestamp', 'suburb_state']]
        
    else:
        # if no outages
        output1 = non_outages_online_customers
        output1['timestamp'] = current_time
    
    count += 1
    time.sleep(data_freq)
    
    if publish:
        # customer modem data stream
        payload1 = json.dumps(output1.to_json(orient='records'))
        future1 = publisher1.publish(topic_path1, payload1.encode("utf-8"))
        # service requests data stream
        payload2 = json.dumps(output2.to_json(orient='records'))
        future2 = publisher2.publish(topic_path2, payload2.encode("utf-8"))
