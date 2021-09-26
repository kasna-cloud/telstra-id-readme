import os
from google.cloud import speech

def stt(stt_uri: str,destination_blob_name: str):
    
    # Speech config
    client = speech.SpeechClient()
    audio = speech.RecognitionAudio(uri=stt_uri)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        language_code="en-US",
    )
    # Speech Call
    response = client.long_running_recognize(config=config, audio=audio)
    # Script writing
    file = open('/tmp/'+destination_blob_name,"w")
    for result in response.result().results:
        for alternative in result.alternatives:
            file.write(alternative.transcript)
    file.close()