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

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = google_compute_address.external_app1.address
      user = var.user-ssh-app-instance
      private_key = file("/home/asus/.ssh/id_ed25519")
    }
    inline = [ 
      "sudo apt update",
      "sudo apt install -y python3",
      "python3 --version"
     ]
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = google_compute_address.external_app1.address
      user = var.user-ssh-app-instance
      private_key = file("/home/asus/.ssh/id_ed25519")
    }
     script = "./docker-install.sh"
  }

  depends_on = [
    google_compute_subnetwork.private,
    google_compute_address.external_app1
    ]

  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-app-instance}:${var.ssh-key-app-instance}"
  }
  description = "Main instance to deploying the app"
  tags        = ["app-instance"]
}