# Main VPC settings

resource "google_compute_network" "vpc_network" {
    name = "vpc-network"
    routing_mode = "GLOBAL"
    auto_create_subnetworks = false
    delete_default_routes_on_create = true
    description = "Main network for GCP resources"
}


# Public subnet settings

resource "google_compute_subnetwork" "public_subnet" {
    name = "public-subnet"
    network = google_compute_network.vpc_network.id
    ip_cidr_range = "10.0.1.0/26"
    description = "A public subnet"
    depends_on = [google_compute_network.vpc_network] 
}


# Private subnet settings

resource "google_compute_subnetwork" "private_subnet" {
    name = "private-subnet"
    network = google_compute_network.vpc_network.id
    ip_cidr_range = "10.0.3.0/26"
    private_ip_google_access = true
    description = "A private subnet"
    depends_on = [google_compute_network.vpc_network]
}


# External address for the app-instance

resource "google_compute_address" "external_ip_app_instance" {
    name = "external-ip-app-instance"
    address_type = "EXTERNAL"
    network_tier = "STANDARD"
}


# Internal address for the app-instance
resource "google_compute_address" "internal_ip_app_instance" {
    name = "internal-ip-app-instance"
    address_type = "INTERNAL"
    address = "10.0.3.3"
    subnetwork = google_compute_subnetwork.private_subnet.id
}