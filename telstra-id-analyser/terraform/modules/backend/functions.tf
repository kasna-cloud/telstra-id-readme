#-----------------------------------------------------------------------------------------
# Submission Handler
#-----------------------------------------------------------------------------------------
resource "google_cloudfunctions_function" "process-handler" {
  name                  = "${var.project_id}-${var.func_analyser_handler}"
  project               = var.project_id
  region                = var.region
  description           = "Analyser Handler"
  runtime               = "python39"
  available_memory_mb   = 1024
  service_account_email = var.analyser-sa-email
  max_instances         = 500
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "${var.project_id}_${var.input_bucket}"
  }
  timeout     = 60
  entry_point = var.entry_point
  source_repository {
    #url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.analyser_repo}/moveable-aliases/${var.branch_name}/paths/python/${var.func_analyser_handler}"
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.analyser_repo}/revisions/${var.commithash}/paths/python/analyser_handler"
  }
  environment_variables = {
    INPUT_BUCKET   = "${var.project_id}_${var.input_bucket}"
    RESULTS_BUCKET = "${var.project_id}_${var.results_bucket}"
    STT_SUFFIX     = var.stt_suffix
    TTS_SUFFIX     = var.tts_suffix
    TTS_VOICE      = var.tts_voice
    VOICE_EXT      = var.voice_ext
    TEXT_EXT       = var.text_ext
    ERROR_MSG      = var.error_msg
  }

  #lifecycle {
  #  ignore_changes = [
  #    labels, source_archive_bucket, source_archive_object
  #  ]
  #}
}
