terraform {
  required_version = "1.12.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.47.0"
    }
  }
}

provider "google" {
    project = "tribal-spanner-467709-v0"
    region = var.google_region
    zone = var.google_zone
}