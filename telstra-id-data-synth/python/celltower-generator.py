"""Publishes multiple cell tower healthcheck status to a Pub/Sub topic with an error handler."""
import json
import os
import random
import time

from google.cloud import pubsub_v1

project_id = os.environ['PROJECT_ID']
#project_id = "telstra-id-data-synth"
topic_id = os.environ['CELLTOWER_PUBSUB_TOPIC']
#topic_id = "celltower_synth"

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)


while True:
    data = {
        "cell_tower_id": random.randrange(10, 99, 1),
        "status": "OFFLINE" if random.randrange(10, 99, 1) % 7 == 0 else "ONLINE",
        "active_connections": random.randrange(1000, 99999, 123),
        "load": random.choice(["low", "moderate", "high", "critical"]),
        "timestamp": time.time()
    }
    payload = json.dumps(data)
    future = publisher.publish(topic_path, payload.encode("utf-8"))
    #print(data)
    time.sleep(0.1)