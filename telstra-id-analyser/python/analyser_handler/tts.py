from google.cloud import texttospeech
import io

def tts(voice: str,data, doc_id: str):
    data = data.decode('utf-8')
    language_code = "-".join(voice.split("-")[:2])
    text_input = texttospeech.SynthesisInput(text=data)
    voice_params = texttospeech.VoiceSelectionParams(
        language_code=language_code, name=voice
    )
    audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.LINEAR16)

    client = texttospeech.TextToSpeechClient()
    response = client.synthesize_speech(
        input=text_input, voice=voice_params, audio_config=audio_config
    )
    return response.audio_content