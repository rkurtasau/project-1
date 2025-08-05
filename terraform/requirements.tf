terraform {
  required_version = "1.12.2"
  required_providers {
    gcp = {
      source  = "hashicorp/google"
      version = "6.47.0"
    }
  }
}

provider "gcp" {
    project = "tribal-spanner-467709-v0"
    region = var.gcp_region
    zone = var.gcp_zone
}