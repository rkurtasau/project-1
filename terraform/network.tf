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


resource "google_compute_address" "external_lb_l7" {
  name         = "external-lb-l7"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  lifecycle {
    create_before_destroy = true
  }
  depends_on   = [google_compute_network.main]
}


resource "google_compute_address" "internal_lb_l7" {
  name         = "internal-lb-l7"
  address_type = "INTERNAL"
  address      = "10.0.1.10"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "L7 load balancer internal address"
}


resource "google_compute_address" "internal_lb1" {
  name         = "internal-lb-1"
  address_type = "INTERNAL"
  address      = "10.0.1.11"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "Load balancer 1(main) internal address"
}


resource "google_compute_address" "internal_lb2" {
  name         = "internal-lb-2"
  address_type = "INTERNAL"
  address      = "10.0.1.12"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "Load balancer 2(reserve) internal address"
}


resource "google_compute_address" "internal_adh1" {
  name         = "internal-adh-1"
  address_type = "INTERNAL"
  address      = "10.0.1.21"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "App docker-host-2 internal address"
}


resource "google_compute_address" "internal_adh2" {
  name         = "internal-adh-2"
  address_type = "INTERNAL"
  address      = "10.0.1.22"
  subnetwork   = google_compute_subnetwork.private.id
  description  = "App docker-host-2 internal address"
}


resource "google_compute_address" "external_management" {
  name = "external-management"
  address_type = "EXTERNAL"
  description = "Management host external address"
}


resource "google_compute_address" "internal_management" {
  name = "internal-management"
  address_type = "INTERNAL"
  address = "10.0.1.30"
  subnetwork = google_compute_subnetwork.private.id
  description = "Management host internal address"
}