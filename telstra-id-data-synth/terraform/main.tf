# ----------------------------------------------------------------------------
# Compute
# ----------------------------------------------------------------------------
module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = "gcr.io/${var.project_id}/datasynth:latest"
    env = [
      {
        name  = "PROJECT_ID"
        value = var.project_id
      },
      {
        name  = "AUST_PUBSUB_TOPIC"
        value = module.cdr_aust.topic
      },
      {
        name  = "INTL_PUBSUB_TOPIC"
        value = module.cdr_intl.topic
      },
      {
        name  = "ALARM_PUBSUB_TOPIC"
        value = module.alarm_synth.topic
      },
      {
        name  = "CELLTOWER_PUBSUB_TOPIC"
        value = module.celltower_synth.topic
      },
      {
        name  = "FAULTS_CUSTOMER_MODEM_DATA_PUBSUB_TOPIC"
        value = module.faults_customer_modem_data.topic
      },
      {
        name  = "FAULTS_SERVICE_REQUESTS_PUBSUB_TOPIC"
        value = module.faults_service_req.topic
      }
    ]
  }
  restart_policy = "Always"
}

resource "google_compute_instance" "datasynth" {
  project      = var.project_id
  name         = "synth-compute"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.synth_subnetwork.name
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = google_service_account.synth_sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# ----------------------------------------------------------------------------
# Network
# ----------------------------------------------------------------------------
resource "google_compute_network" "synth_network" {
  project                 = var.project_id
  name                    = var.vpc-network
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "synth_subnetwork" {
  project            = var.project_id
  subnetwork_project = var.project_id
  name               = "synth-subnetwork"
  ip_cidr_range      = "10.152.0.0/24"
  region             = "australia-southeast1"
  network            = google_compute_network.synth_network.id
}

# ----------------------------------------------------------------------------
# Firewall
# ----------------------------------------------------------------------------
resource "google_compute_firewall" "default" {
  project = var.project_id
  name    = "ssh"
  network = google_compute_network.synth_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_project_service.gcp_services]
}


# ----------------------------------------------------------------------------
# PubSub
# ----------------------------------------------------------------------------
module "cdr_aust" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "cdr_aust"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "cdr_aust"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}

module "cdr_intl" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "cdr_intl"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "cdr_intl"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}

module "alarm_synth" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "alarm_synth"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "alarm_synth"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}

module "celltower_synth" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "celltower_synth"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "celltower_synth"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}

module "faults_customer_modem_data" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "faults_customer_modem_data"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "faults_customer_modem_data"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}
module "faults_service_req" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "faults_service_req"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "faults_service_req"
      dead_letter_topic    = module.dead-letter.id
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}
module "dead-letter" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.7"

  topic               = "dead_letter"
  project_id          = var.project_id
  grant_token_creator = false

  pull_subscriptions = [
    {
      name                 = "dead_letter"
      expiration_policy    = ""
      ack_deadline_seconds = 300
    }
  ]
}
resource "google_pubsub_topic_iam_member" "cdr_intl" {
  project    = var.project_id
  topic      = module.cdr_intl.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}

resource "google_pubsub_topic_iam_member" "cdr_aust" {
  project    = var.project_id
  topic      = module.cdr_aust.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}

resource "google_pubsub_topic_iam_member" "alarm_synth" {
  project    = var.project_id
  topic      = module.alarm_synth.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}

resource "google_pubsub_topic_iam_member" "celltower_synth" {
  project    = var.project_id
  topic      = module.celltower_synth.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}
resource "google_pubsub_topic_iam_member" "faults_customer_modem_data" {
  project    = var.project_id
  topic      = module.faults_customer_modem_data.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}
resource "google_pubsub_topic_iam_member" "faults_service_req" {
  project    = var.project_id
  topic      = module.faults_service_req.topic
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on = [google_project_service.gcp_services]
}

# ----------------------------------------------------------------------------
# APIs to enable - Review required APIs in Variables
# ----------------------------------------------------------------------------
resource "google_project_service" "gcp_services" {
  count                      = length(var.gcp_service_list)
  project                    = var.project_id
  service                    = var.gcp_service_list[count.index]
  disable_dependent_services = false
  disable_on_destroy         = false
}

# ----------------------------------------------------------------------------
# IAM
# ----------------------------------------------------------------------------
module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"

  projects = [var.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/storage.admin" = [
      "serviceAccount:${google_service_account.synth_sa.email}",
    ]
  }
}

resource "google_service_account" "synth_sa" {
  project      = var.project_id
  account_id   = "synth-sa"
  display_name = "Synth Service Account"
  description  = "Service Account to run synthersizers as"
}

