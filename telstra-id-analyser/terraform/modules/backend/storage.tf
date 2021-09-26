#-------------------------------------------------------
# Storage
#-------------------------------------------------------
resource "google_storage_bucket" "input_bucket" {
  name                        = "${var.project_id}_${var.input_bucket}"
  project                     = var.project_id
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket" "results_bucket" {
  name                        = "${var.project_id}_${var.results_bucket}"
  project                     = var.project_id
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}