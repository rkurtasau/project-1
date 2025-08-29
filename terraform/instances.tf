resource "google_compute_instance" "app_docker_host_1" {
  name         = "app-docker-host-1"
  machine_type = "e2-standard-2"

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_adh1.address
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
    google_compute_address.internal_adh1
    ]
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-app-instance}:${var.ssh-key-app-instance}"
    }
  description = "Main docker-host application deploying"
  tags        = ["app-docker-host-1"]
}


resource "google_compute_instance" "app_docker_host_2" {
  name         = "app-docker-host-2"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_adh2.address
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
    google_compute_address.internal_adh2
    ]
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-app-instance}:${var.ssh-key-app-instance}"
    }
  description = "Reserve docker-host application deploying"
  tags        = ["app-docker-host-2"]
}