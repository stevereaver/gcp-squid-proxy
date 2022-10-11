# ----------------------------------------------------------------------------
# Firewall for Allowing TCP3128 from IAP
# ----------------------------------------------------------------------------
resource "google_compute_firewall" "ingress-ip-iap" {
  project = var.project_id
  name    = "allow-ingress-squid-from-iap"
  network = var.network

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["3128"]
  }
  source_ranges = ["35.235.240.0/20"]
}