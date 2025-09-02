resource "google_compute_network" "main" {
  name                    = "main"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = 1460
  description             = "Main network for GCP resources"
}


resource "google_compute_subnetwork" "private" {
  name          = "private"
  network       = google_compute_network.main.id
  ip_cidr_range = "10.0.1.0/24"
  description   = "A subnet"
  depends_on    = [google_compute_network.main]
}


resource "google_compute_address" "internal_lb1" {
  name         = "internal-lb-1"
  address_type = "INTERNAL"
  address      = "10.0.1.11"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "Load balancer 1(main) internal address"
}


resource "google_compute_address" "internal_adh1" {
  name         = "internal-adh-1"
  address_type = "INTERNAL"
  address      = "10.0.1.21"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "App docker-host-2 internal address"
}


resource "google_compute_address" "external_management" {
  name         = "external-management"
  address_type = "EXTERNAL"
  description  = "Management host external address"
}


resource "google_compute_address" "internal_management" {
  name         = "internal-management"
  address_type = "INTERNAL"
  address      = "10.0.1.30"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "Management host internal address"
}