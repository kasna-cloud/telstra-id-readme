resource "google_app_engine_application" "datastore" {
  project       = var.project_id
  location_id   = var.location
  database_type = "CLOUD_DATASTORE_COMPATIBILITY"
}