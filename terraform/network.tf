resource "google_compute_network" "vpc_network" {
    name = "vpc-network"
    routing_mode = "GLOBAL"
    auto_create_subnetworks = false
    delete_default_routes_on_create = true
    description = "Main network for GCP resources"
}