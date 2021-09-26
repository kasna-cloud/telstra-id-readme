#-----------------------------------------------------------------------------------------
# API Gateway
#-----------------------------------------------------------------------------------------
resource "google_api_gateway_api" "api" {
  project  = var.project_id
  provider = google-beta
  api_id   = var.api_id
}

resource "google_api_gateway_api_config" "api_gw" {
  project              = var.project_id
  provider             = google-beta
  api                  = google_api_gateway_api.api.api_id
  api_config_id_prefix = var.api_config_id_prefix

  openapi_documents {
    document {
      path     = "${var.api_yaml_path}${var.api_yaml}"
      contents = filebase64("${var.api_yaml_path}${var.api_yaml}")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "google_api_gateway_gateway" "api_gw" {
  provider   = google-beta
  project    = var.project_id
  region     = var.region
  api_config = google_api_gateway_api_config.api_gw.id
  gateway_id = var.api_gateway_id
}
