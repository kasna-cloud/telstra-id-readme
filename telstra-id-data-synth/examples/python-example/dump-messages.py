#------------------------------------------------------------------------
# Example code to create pull subscription to cdr_intl 
# and print the results
#------------------------------------------------------------------------

from google.cloud import pubsub_v1
from concurrent.futures import TimeoutError

project_id = "telstra-id-data-synth"
topic_id = "cdr_aust"
subscription_id = "cdr_aust"
# Number of seconds the subscriber should listen for messages
timeout = 5.0

publisher = pubsub_v1.PublisherClient()
subscriber = pubsub_v1.SubscriberClient()
topic_path = publisher.topic_path(project_id, topic_id)
# The `subscription_path` method creates a fully qualified identifier
# in the form `projects/{project_id}/subscriptions/{subscription_id}`
subscription_path = subscriber.subscription_path(project_id, subscription_id)

def callback(message: pubsub_v1.subscriber.message.Message) -> None:
    print(f"Received {message}.")
    message.ack()

streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
print(f"Listening for messages on {subscription_path}..\n")

# Wrap subscriber in a 'with' block to automatically call close() when done.
with subscriber:
    try:
        # When `timeout` is not set, result() will block indefinitely,
        # unless an exception is encountered first.
        streaming_pull_future.result(timeout=timeout)
    except TimeoutError:
           streaming_pull_future.cancel()  # Trigger the shutdown.
           streaming_pull_future.result()  # Block until the shutdown is complete.