variable "project_id" {
  type        = string
  description = "The project ID to deploy resource into"
}
variable "region" {
  type        = string
  description = "The region where all resources will be deployed"
}
variable "location" {
  type = string
}
variable "api-sa-email" {
  description = "The service account email"
  type        = any
}
variable "analyser_repo" {
  type = string
}
variable "branch_name" {
  type = string
}
variable "func_api_handler" {
  type = string
}
variable "entry_point" {
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