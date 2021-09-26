import os

from stt import stt
from tts import tts
from common import get_trigger_uri, get_trigger_name, get_trigger_uri, get_trigger_bucket, upload_txt, upload_wav, download

# Definitions
destination_bucket_name = os.environ.get('RESULTS_BUCKET')
project_name = os.environ.get('PROJECT_ID')
stt_suffix = os.environ.get('STT_SUFFIX')
tts_suffix = os.environ.get('TTS_SUFFIX')
tts_voice = os.environ.get('TTS_VOICE')
voice_extensions = os.environ.get('VOICE_EXT')
text_extensions = os.environ.get('TEXT_EXT')
error_message = os.environ.get('ERROG_MSG')


def handler(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    extension = os.path.splitext(get_trigger_name(event))[1]
#     print ("Destination bucket name: "+destination_bucket_name)
    destination_blob_name = None

    if extension in voice_extensions:
        # Speech
        destination_blob_name = speech(event)
        upload_wav(destination_bucket_name, destination_blob_name)
        os.remove('/tmp/'+destination_blob_name)
    elif extension in text_extensions:
        # text
        destination_blob_name, response_text = text(event)
        upload_txt(destination_bucket_name, destination_blob_name, response_text)
    else:
        print(error_message)
        return error_message
    # File upload


def speech(event):
    destination_blob_name = os.path.splitext(get_trigger_name(event))[0] + stt_suffix
    stt(get_trigger_uri(event), destination_blob_name)
    return destination_blob_name


def text(event):
    destination_blob_name = os.path.splitext(get_trigger_name(event))[0] + tts_suffix
    data = download(get_trigger_bucket(event), get_trigger_name(event))
    response_text = tts(tts_voice, data, destination_blob_name)
    return destination_blob_name, response_text
