module "proxy_cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project_id
  name    = "proxy-cloud-router"
  network = var.network
  region  = var.region
  nats = [{
    name                                = "proxy-nat-gateway",
    enable_endpoint_independent_mapping = true,
    icmp_idle_timeout_sec               = 30,
    nat_ip_allocate_option              = "MANUAL_ONLY",
    nat_ips                             = toset([google_compute_address.squid-public-ip.self_link]),
    source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES",
    tcp_established_idle_timeout_sec    = 1200,
    tcp_transitory_idle_timeout_sec     = 30,
    udp_idle_timeout_sec                = 30,
  }]
}

resource "google_compute_address" "squid-public-ip" {
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  name         = "squid-public-ip"
}