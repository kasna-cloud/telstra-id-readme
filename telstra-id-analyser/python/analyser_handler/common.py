from google.cloud import storage

def get_trigger_name(event):
    return event['name']

def get_trigger_bucket(event):
    return event['bucket']
    
def get_trigger_uri(event):
    return "gs://"+get_trigger_bucket(event)+"/"+get_trigger_name(event)

def get_document_id(event):
    return hash_key(event['name'])

def upload_txt(destination_bucket, destination_name, body):
    # File upload
    storage_client = storage.Client()
    bucket = storage_client.bucket(destination_bucket)
    blob = bucket.blob(destination_name)
    return blob.upload_from_string(body)

def upload_wav(destination_bucket, destination_name):
    # File upload
    storage_client = storage.Client()
    bucket = storage_client.bucket(destination_bucket)
    blob = bucket.blob(destination_name)
    return blob.upload_from_filename('/tmp/'+destination_name)


def download(origin_bucket, origin_name):
    storage_client = storage.Client()
    source_bucket = storage_client.bucket(origin_bucket)
    blob = source_bucket.blob(origin_name)
    return blob.download_as_string()