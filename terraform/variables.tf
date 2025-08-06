variable "google_provider" {
  default = "google"
  type = string
  description = "google provider for terraform resources"
}

variable "google_region" {
  default     = "us-central1"
  type        = string
  description = "Default GCP region"
}

variable "google_zone" {
  default = "us-central1-c"
  type    = string
  description = "Default GCP zone"
}