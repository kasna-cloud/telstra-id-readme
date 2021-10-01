variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "location" {
  type = string
}
variable "analyser_repo" {
  type = string
}
variable "branch_name" {
  type = string
}
variable "func_analyser_handler" {
  type = string
}
variable "func_api_handler" {
  type = string
}
variable "entry_point" {
  type = string
}
variable "input_bucket" {
  type = string
}
variable "results_bucket" {
  type = string
}
variable "api_id" {
  type = string
}
variable "api_gateway_id" {
  type = string
}
variable "api_config_id_prefix" {
  type = string
}
variable "api_yaml" {
  type = string
}
variable "api_yaml_path" {
  type = string
}
variable "commithash" {
  type = string
}
variable "stt_suffix" {
  type = string
}
variable "tts_suffix" {
  type = string
}
variable "tts_voice" {
  type = string
}
variable "voice_ext" {
  type = string
}
variable "text_ext" {
  type = string
}
variable "error_msg" {
  type = string
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
    "secretmanager.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "appengine.googleapis.com",
    "apigateway.googleapis.com",
    "serviceusage.googleapis.com",
    "apigateway.googleapis.com",
    "servicecontrol.googleapis.com"
  ]
}