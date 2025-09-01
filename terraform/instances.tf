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
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
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
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
    }
  description = "Reserve docker-host application deploying"
  tags        = ["app-docker-host-2"]
}


resource "google_compute_instance" "management_host" {
  name         = "management-host"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_management.address
    access_config {
    nat_ip = google_compute_address.external_management.address
    }
  }
  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
    auto_delete = false
  }
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
  }
  depends_on = [ 
    google_compute_subnetwork.private,
    google_compute_address.internal_management,
    google_compute_address.external_management
  ]
  description = "Management host"
  tags = [ "management-host" ]
}


resource "google_compute_instance" "lbL7" {
  name         = "load-balancer-L7"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_lb_l7.address
    access_config {
    nat_ip = google_compute_address.external_lb_l7.address
    }
  }
  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
    auto_delete = false
  }
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
  }
  depends_on = [ 
    google_compute_subnetwork.private,
    google_compute_address.internal_lb_l7,
    google_compute_address.external_lb_l7
  ]
  description = "Load Balancer Layer 7 host"
  tags = [  ]
}


resource "google_compute_instance" "lb1" {
  name         = "load-balancer-1"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_lb1.address
  }
  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
    auto_delete = false
  }
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
  }
  depends_on = [ 
    google_compute_subnetwork.private,
    google_compute_address.internal_lb1
  ]
  description = "Load Balancer 1 host"
  tags = [  ]
}


resource "google_compute_instance" "lb2" {
  name         = "load-balancer-2"
  machine_type = "e2-standard-2"
  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    network_ip = google_compute_address.internal_lb2.address
  }
  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
    auto_delete = false
  }
  allow_stopping_for_update = true
  metadata = {
    ssh-keys = "${var.user-ssh-adh}:${var.ssh-key-adh}"
  }
  depends_on = [ 
    google_compute_subnetwork.private,
    google_compute_address.internal_lb2
  ]
  description = "Load Balancer 2 host"
  tags = [  ]
}