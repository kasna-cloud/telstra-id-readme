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
variable "analyser-sa-email" {
  description = "The service account email"
  type        = any
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
variable "entry_point" {
  type = string
}
variable "input_bucket" {
  type = string
}
variable "results_bucket" {
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