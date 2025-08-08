# App instance settings

resource "google_compute_instance" "app_instance" {
  name = "app-instance"
  machine_type = "c2d-standard-2"
  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_1.id
    network_ip = google_compute_address.internal_ip_app_instance.id
    access_config {
      nat_ip = google_compute_address.external_ip_app_instance.address
      network_tier = "STANDARD"
    }
  }
  boot_disk {
    source = google_compute_disk.app_instance_disk.id 
    }
  depends_on = [ 
    google_compute_subnetwork.subnet_1,
    google_compute_disk.app_instance_disk ]
  allow_stopping_for_update = true
  description = "Main instance to deploying the app"
}

resource "google_compute_disk" "app_instance_disk" {
    name = "app-instance-disk"
    type = "pd-standard"
    image = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-arm64"
    size = 30
    description = "The disk attached to the app_instance"
}