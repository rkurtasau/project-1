resource "google_compute_instance" "app_instance" {
  name         = "app-instance"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_app1.address
    access_config {
      nat_ip       = google_compute_address.external_app1.address
      network_tier = "STANDARD"
    }
  }
  boot_disk {
    initialize_params {
      size  = 30
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
    auto_delete = false
  }
  depends_on = [
    google_compute_subnetwork.private,
    google_compute_address.external_app1,
  google_compute_firewall.ssh_access]
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-app-instance}:${var.ssh-key-app-instance}"
  }
  description = "Main instance to deploying the app"
  tags        = ["app-instance"]
}