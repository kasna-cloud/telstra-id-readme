variable "project_id" {
  default = "telstra-id-data-synth"
}
variable "region" {
  default = "australia-southeast1"
}
variable "zone" {
  default = "australia-southeast1-a"
}
variable "vpc-network" {
  default = "vpc-network"
}


# ----------------------------------------------------------------------------
# APIs need for project
# ----------------------------------------------------------------------------
variable "gcp_service_list" {
  description = "List of GCP APIs that are required by project"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "pubsub.googleapis.com",
    "containerregistry.googleapis.com",
  ]
}
