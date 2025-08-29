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


resource "google_compute_firewall" "ssh_access" {
  name          = "ssh-access"
  network       = google_compute_network.main.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  lifecycle {
    create_before_destroy = true
  }
  allow {
    protocol = "TCP"
    ports    = [22]
  }
  depends_on  = [google_compute_network.main]
  target_tags = ["app-instance"]
}


resource "google_compute_firewall" "outbound_access" {
  name      = "outbound-access"
  network   = google_compute_network.main.id
  direction = "EGRESS"
  allow {
    protocol = "TCP"
    ports    = [80, 443]
  }
  target_tags = ["app-instance"]
}


resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.main.id
  region  = "us-central1"
}


resource "google_compute_router_nat" "router_nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  depends_on = [google_compute_router.router]
}