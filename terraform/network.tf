resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = 1460
  description             = "Main network for GCP resources"
}


resource "google_compute_subnetwork" "subnet_1" {
  name          = "subnet-1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.1.0/24"
  description   = "A subnet"
  depends_on    = [google_compute_network.vpc_network]
}


resource "google_compute_address" "external_ip_app_instance1" {
  name         = "external-ip-app-instance1"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_address" "internal_ip_app_instance" {
  name         = "internal-ip-app-instance"
  address_type = "INTERNAL"
  address      = "10.0.1.3"
  subnetwork   = google_compute_subnetwork.subnet_1.id
}


resource "google_compute_firewall" "ssh_access" {
  name          = "ssh-access"
  network       = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  lifecycle {
    create_before_destroy = true
  }
  allow {
    protocol = "TCP"
    ports    = [22]
  }
  depends_on  = [google_compute_network.vpc_network]
  target_tags = ["app-instance"]
}


resource "google_compute_firewall" "outbound_access" {
  name      = "outbound-access"
  network   = google_compute_network.vpc_network.id
  direction = "EGRESS"
  allow {
    protocol = "TCP"
    ports    = [80, 443]
  }
  target_tags = ["app-instance"]
}


resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc_network.id
  region  = "us-central1"
}


resource "google_compute_router_nat" "router_nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet_1.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  depends_on = [google_compute_router.router]
}