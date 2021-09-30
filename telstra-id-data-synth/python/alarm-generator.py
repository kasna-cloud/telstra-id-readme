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
topic_id = os.environ['ALARM_PUBSUB_TOPIC']

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)
publish_futures = []

servers = ["ssoneweb001","ssoneweb002","ssoneapp001","ssoneapp002","ssonedb001","ssonedb002","lxonesmtp001","lxonesmtp002","wstsdpapp001","wstsdpapp001","ssessapp001","ssessapp002","ssessapp003","ssessapp004"]
switches = ["pitt-idc-s01","pitt-idc-s02","pitt-tcom-s01","pitt-tcom-s02","pitt-ess-s01","pitt-ess-s01","exhi-tsdp-s01","exhi-tsdp-s01"]
routers = ["pitt-tcom-r01","pitt-tcom-r02","pitt-idc-r01","pitt-idc-r02","exhi-idc-r01","exhi-idc-r02"]
devices = [servers,switches,routers]

# Alert types
server_alerts = ["disk","cpu","fan","PSU","temp","memory","ECC","smtp","http","ssh"]
switch_alerts = ["port","S/T","fan","PSU","link","aggregation"]
router_alerts = ["port","memory","cpu","fan","PSU","link","duplicate_ip"]

while True:
  # Determine device
  device_type = random.choice(devices)
  device = random.choice(device_type)

  if device_type == servers:
      alert = random.choice(server_alerts)
    
  if device_type == switches:
      alert = random.choice(switch_alerts)
    
  if device_type == routers:
      alert = random.choice(router_alerts)
    
  today = date.today()
  now = datetime.now()

  delay = random.randint(1,10)
  time.sleep(delay)
  
  data = (today.strftime("%y%m%d")+","+now.strftime("%H%M%S")+","+device+","+alert)
  data = data.encode("utf-8")
  future = publisher.publish(topic_path, data)