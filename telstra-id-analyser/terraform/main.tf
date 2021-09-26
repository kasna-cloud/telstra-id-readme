# ----------------------------------------------------------------------------
# APIs to enable
# ----------------------------------------------------------------------------
resource "google_project_service" "gcp_services" {
  count                      = length(var.gcp_service_list)
  project                    = var.project_id
  service                    = var.gcp_service_list[count.index]
  disable_dependent_services = false
  disable_on_destroy         = false
}

#-------------------------------------------------------
# IAM
#-------------------------------------------------------
module "iam" {
  source         = "./modules/iam"
  project_id     = var.project_id
  region         = var.region
  project_number = data.google_project.project.number
  depends_on     = [google_project_service.gcp_services]
}

#-------------------------------------------------------
# Frontend Module
#-------------------------------------------------------
module "frontend" {
  source               = "./modules/frontend"
  project_id           = var.project_id
  region               = var.region
  analyser_repo        = var.analyser_repo
  branch_name          = var.branch_name
  func_api_handler     = var.func_api_handler
  api-sa-email         = module.iam.api-sa-email
  entry_point          = var.entry_point
  location             = var.location
  api_id               = var.api_id
  api_gateway_id       = var.api_gateway_id
  api_config_id_prefix = var.api_config_id_prefix
  api_yaml             = var.api_yaml
  api_yaml_path        = var.api_yaml_path
  commithash           = var.commithash
}

#-------------------------------------------------------
# Backend Module
#-------------------------------------------------------
module "backend" {
  source                = "./modules/backend"
  project_id            = var.project_id
  region                = var.region
  input_bucket          = var.input_bucket
  results_bucket        = var.results_bucket
  analyser_repo         = var.analyser_repo
  branch_name           = var.branch_name
  func_analyser_handler = var.func_analyser_handler
  analyser-sa-email     = module.iam.analyser-sa-email
  entry_point           = var.entry_point
  location              = var.location
  commithash            = var.commithash
  stt_suffix            = var.stt_suffix
  tts_suffix            = var.tts_suffix
  tts_voice             = var.tts_voice
  voice_ext             = var.voice_ext
  text_ext              = var.text_ext
  error_msg             = var.error_msg

}

# ----------------------------------------------------------------------------
# Project Data
# ----------------------------------------------------------------------------
data "google_project" "project" {
  project_id = var.project_id
}