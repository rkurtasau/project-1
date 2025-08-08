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
    project = var.google_project
    region = var.google_region
    zone = var.google_zone
}