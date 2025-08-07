# App instance settings

resource "google_compute_instance" "app_instance" {
  name = "app-instance"
  machine_type = "custom-4-6144"
  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.private_subnet.id
    network_ip = "10.0.3.3"
  }
  boot_disk {
    source = google_compute_disk.app_instance_disk.id 
    }
  depends_on = [ google_compute_subnetwork.private_subnet ]
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