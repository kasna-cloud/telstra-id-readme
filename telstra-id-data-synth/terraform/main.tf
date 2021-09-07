# ----------------------------------------------------------------------------
# Compute
# ----------------------------------------------------------------------------
resource "google_compute_instance" "default" {
  project                   = var.project_id
  name                      = "synth-compute"
  machine_type              = "g1-small"
  allow_stopping_for_update = true
  zone                      = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20210825"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      // Ephemeral public IP
    }
  }
  metadata = {
    aust_pubsub_topic = module.cdr_aust.topic
    intl_pubsub_topic = module.cdr_intl.topic
    alarm_pubsub_topic = module.alarm_synth.topic
  }

  # Install Stack Driver, Log Agents & Update
  metadata_startup_script = <<EOF
    #! /bin/bash
    timedatectl set-timezone Australia/Sydney
    export PROJECT_ID=`curl "http://metadata/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"`
    export AUST_PUBSUB_TOPIC=`curl "http://metadata/computeMetadata/v1/instance/attributes/aust_pubsub_topic" -H "Metadata-Flavor: Google"`
    export INTL_PUBSUB_TOPIC=`curl "http://metadata/computeMetadata/v1/instance/attributes/intl_pubsub_topic" -H "Metadata-Flavor: Google"`
    export ALARM_PUBSUB_TOPIC=`curl "http://metadata/computeMetadata/v1/instance/attributes/alarm_pubsub_topic" -H "Metadata-Flavor: Google"`
    curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
    bash add-monitoring-agent-repo.sh
    apt update
    apt -y install stackdriver-agent
    service stackdriver-agent start
    curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh 
    bash add-logging-agent-repo.sh 
    apt update 
    apt -y install google-fluentd google-fluentd-catch-all-config 
    service google-fluentd start
    apt -y upgrade
    apt -y install python3 python3-pip
    pip3 install google-cloud-pubsub
    pip3 install scipy
    echo '${base64decode(google_service_account_key.synth_key.private_key)}' > /key.json
    export GOOGLE_APPLICATION_CREDENTIALS="/key.json"
    git clone https://telstra-id-data-synth-gen_bot:${data.google_secret_manager_secret_version.gitlab_token.secret_data}@gitlab.mantelgroup.com.au/kasna/customers/telstra-id/telstra-id-data-synth.git -b main
    cd telstra-id-data-synth/python
    python3 ./australian-cdr-generator.py & 
    python3 ./international-cdr-generator.py &
    python3 ./alarm-generator.py &
  EOF
  depends_on              = [google_project_service.gcp_services, google_compute_network.vpc_network, google_project_iam_policy.compute_sa]
}

data "google_secret_manager_secret_version" "gitlab_token" {
  project = var.project_id
  secret  = "GITLAB_TOKEN"
}

# ----------------------------------------------------------------------------
# Service Account that is perminted to write to Topic
# ----------------------------------------------------------------------------
resource "google_service_account" "synth_sa" {
  project      = var.project_id
  account_id   = "synth-sa"
  display_name = "Service Account to run synthersizers as"
}

resource "google_service_account_key" "synth_key" {
  service_account_id = google_service_account.synth_sa.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# ----------------------------------------------------------------------------
# Network
# ----------------------------------------------------------------------------
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc-network
  auto_create_subnetworks = true
}

# ----------------------------------------------------------------------------
# Firewall
# ----------------------------------------------------------------------------
resource "google_compute_firewall" "default" {
  project = var.project_id
  name    = "ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on              = [google_project_service.gcp_services]
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
  project = var.project_id
  topic   = module.cdr_intl.topic
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on              = [google_project_service.gcp_services]
}

resource "google_pubsub_topic_iam_member" "cdr_aust" {
  project = var.project_id
  topic   = module.cdr_aust.topic
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on              = [google_project_service.gcp_services]
}

resource "google_pubsub_topic_iam_member" "alarm_synth" {
  project = var.project_id
  topic   = module.alarm_synth.topic
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.synth_sa.email}"
  depends_on              = [google_project_service.gcp_services]
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
resource "google_project_iam_policy" "compute_sa" {
  project     = var.project_id
  policy_data = data.google_iam_policy.compute_sa.policy_data
}

data "google_iam_policy" "compute_sa" {
  binding {
    role = "roles/compute.admin"

    members = [
      "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
      "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
    ]
  }
}

data "google_project" "project" {
  project_id = var.project_id
}

