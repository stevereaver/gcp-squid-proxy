#-------------------------------------------------------
# Squid Service Account
#-------------------------------------------------------
resource "google_service_account" "iap_squid_proxy_sa" {
  project      = var.project_id
  account_id   = "iap-squid-proxy-sa"
  display_name = "Squid Proxy Service Account"
}

#-------------------------------------------------------
# Project Bindings
#-------------------------------------------------------
module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"

  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/monitoring.admin" = [
      "serviceAccount:${google_service_account.iap_squid_proxy_sa.email}"
    ]
    "roles/logging.logWriter" = [
      "serviceAccount:${google_service_account.iap_squid_proxy_sa.email}"
    ]
    "roles/owner" = [
      "serviceAccount:${google_service_account.gitlab_runner_sa.email}"
    ]
  }
}

# ----------------------------------------------------------------------------
# User to permit in the IAP tunnel
# ----------------------------------------------------------------------------
resource "google_iap_tunnel_iam_binding" "iap_binding" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  members = var.iap_users
}

# ----------------------------------------------------------------------------
# APIs to enable
# ----------------------------------------------------------------------------
resource "google_project_service" "gcp_services" {
  count                      = length(var.gcp_service_list)
  project                    = var.project_id
  service                    = var.gcp_service_list[count.index]
  disable_dependent_services = false
  disable_on_destroy         = false
}
