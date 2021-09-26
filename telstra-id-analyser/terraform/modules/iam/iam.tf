module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"

  projects = [var.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/run.admin" = [
      "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudbuild.builds.builder" = [
      "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudfunctions.invoker" = [
      "serviceAccount:${google_service_account.analyser-sa.email}",
      "serviceAccount:${google_service_account.api-sa.email}"
    ]
    "roles/datastore.user" = [
      "serviceAccount:${google_service_account.analyser-sa.email}",
      "serviceAccount:${google_service_account.api-sa.email}"
    ]
    "roles/storage.objectAdmin" = [
      "serviceAccount:${google_service_account.analyser-sa.email}"
    ]
  }
}

resource "google_service_account" "analyser-sa" {
  project      = var.project_id
  account_id   = "analyser-sa"
  display_name = "Analyser Service Account"
  description  = "SA for running functions"
}

resource "google_service_account" "api-sa" {
  project      = var.project_id
  account_id   = "api-sa"
  display_name = "API Service Account"
  description  = "SA for running functions"
}