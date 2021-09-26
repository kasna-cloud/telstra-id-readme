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
topic_id = os.environ['INTL_PUBSUB_TOPIC']

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)
publish_futures = []

code_intl = ["93","355","213","1684","376","244","1264","672","1268","54","374","297","247","672","43","994","1242","973","880","1246","1268","375","32","501","229","1441","975","591","387","267","55","1284","673","359","226","257","855","237","1","238","1345","236","235","64","56","86","618","61","57","269","242","243","682","506","225","385","53","5399","599","357","420","45","246","253","1767","1809","670","56","593","20","503","8812","88213","240","291","372","251","500","298","679","358","33","596","594","689","241","220","995","49","233","350","30","299","1473","590","1671","5399","502","245","224","592","509","504","852","36","8810","354","91","62","871","874","873","872","870","800","808","98","964","353","972","39","1876","81","7","254","686","850","82","383","965","996","856","371","961","266","231","218","423","370","352","853","389","261","265","60","960","223","356","692","596","222","230","269","52","691","1808","373","377","976","382","1664","212","258","95","264","674","977","31","599","1869","687","64","505","227","234","683","672","1670","47","968","92","680","970","507","675","595","51","63","48","351","1787","974","262","40","250","290","1869","1758","508","1784","685","378","239","966","221","381","248","232","65","421","386","677","252","27","34","94","249","597","268","46","41","963","886","992","255","66","88216","670","228","690","676","1868","216","90","993","1649","688","256","380","971","44","1","1340","878","598","998","678","39","58","84","808","681","967","260","255","263"]

# cc = call collision
# nc = no connect
# en = engaged
# ms = message service
# an = answered

status_list = ['cc'] * 3 + ['nc'] * 2 + ['en'] * 4 + ['ms'] * 6 + ['an'] * 85 

while True:
  # Determine Country
  country = random.choice(code_intl)
  # Determine Direction
  direction = 0
  direction = random.getrandbits(1)
  # Source number
  src_number = str(random.randint(100000000,999999999))
  # Dest Number
  dest_number = str(random.randint(100000000,999999999))

  if direction == 0: 
      src_country = "61"
      dest_country = country
  else:
      src_country = country
      dest_country = "61"

  # Stadard deviationfor call length
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

  data = today.strftime("%y%m%d")+","+now.strftime("%H%M%S")+","+src_country+src_number+","+dest_country+dest_number+","+random.choice(status_list)+","+str(length)
  data = data.encode("utf-8")
  future = publisher.publish(topic_path, data)