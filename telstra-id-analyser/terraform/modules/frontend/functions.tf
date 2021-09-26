#-----------------------------------------------------------------------------------------
# Submission Handler
#-----------------------------------------------------------------------------------------
resource "google_cloudfunctions_function" "api-handler" {
  name                  = "${var.project_id}-${var.func_api_handler}"
  project               = var.project_id
  region                = var.region
  description           = "API Handler"
  runtime               = "python39"
  available_memory_mb   = 1024
  service_account_email = var.api-sa-email
  max_instances         = 500
  trigger_http          = true
  timeout               = 60
  entry_point           = var.entry_point
  source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.analyser_repo}/revisions/${var.commithash}/paths/telstra-id-analyser/python/api_handler"
  }

  #lifecycle {
  #  ignore_changes = [
  #    labels, source_archive_bucket, source_archive_object
  #  ]
  #}
}