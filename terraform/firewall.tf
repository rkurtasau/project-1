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
  target_tags = ["management-host", "app-docker-host", "load-balancer"]
}


resource "google_compute_firewall" "inbound_access" {
  name          = "inbound-access"
  network       = google_compute_network.main.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "TCP"
    ports    = [80, 443]
  }
  target_tags = []
}


resource "google_compute_firewall" "outbound_access" {
  name      = "outbound-access"
  network   = google_compute_network.main.id
  direction = "EGRESS"
  allow {
    protocol = "TCP"
    ports    = [80, 443]
  }
  target_tags = []
}