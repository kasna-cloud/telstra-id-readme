# coding=utf-8
__author__ = "Stephen Bancroft"
__email__ = "stephen.bancroft@kasna.com.au"

import time
import random
import os
from scipy import stats
from random import randrange
from datetime import date
from datetime import datetime
from concurrent import futures
from google.cloud import pubsub_v1

project_id = os.environ['PROJECT_ID']
topic_id = os.environ['AUST_PUBSUB_TOPIC']

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)
publish_futures = []

code_aus = ["02","03","04","07","08"]

# cc = call collision
# nc = no connect
# en = engaged
# ms = message service
# an = answered

status_list = ['cc'] * 3 + ['nc'] * 2 + ['en'] * 4 + ['ms'] * 6 + ['an'] * 85 

while True:
  # Determine orign
  call_origin_code = random.choice(code_aus)
  if call_origin_code == "04":
      number_origin = format((random.randint(00000000,19999999)), '08d')
  else:
      number_origin = str(random.randint(80000000,99999999))

  # Determine destination
  call_dest_code = random.choice(code_aus)
  if call_dest_code == "04":
      number_dest = format((random.randint(00000000,19999999)), '08d')
  else:
      number_dest = str(random.randint(80000000,99999999))
 
  # Stadard deviation for call length
  centre_of_dist = 180
  standard_dev = 1 * 60 * 60

  # If negative call length, then try again
  length = 0
  while length < 1:
      length = int(stats.norm.rvs(loc=centre_of_dist, scale=standard_dev, size=1))

  today = date.today()
  now = datetime.now()

  delay = random.randint(1,10)
  time.sleep(delay/10)
  
  data = today.strftime("%y%m%d")+","+now.strftime("%H%M%S")+","+call_origin_code+number_origin+","+call_dest_code+number_dest+","+random.choice(status_list)+","+str(length)
  data = data.encode("utf-8")
  future = publisher.publish(topic_path, data)