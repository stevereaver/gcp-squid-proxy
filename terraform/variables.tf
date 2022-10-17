variable "project_id" {
  description = "The project to deploy to"
  type        = string
}
variable "region" {
  description = "The region to deploy to"
  type        = string
}
variable "zone" {
  description = "The zone to deploy to"
  type        = string
}
variable "network" {
  description = "The network to deploy to, if not specified 'default' will be used"
  type        = string
  default     = "default"
}
variable "subnetwork" {
  description = "The subnetwork to deploy to, if not specified 'default' will be used"
  type        = string
  default     = "default"
}

variable "network_tag" {
  description = "The network tag to use for the instance"
  type        = list(string)
  default     = ["squid-proxy"]
}
variable "iap_users" {
  description = "List of IAM user that can use the IAP tunnel"
  type        = list(string)
}
variable "firewall_enable_logging" {
  description = "Enable logging in firewall"
  type = bool
  default = "true"  
}
variable "squid_sa_name" {
  description = "Name of the service account"
  type = string
  default = "iap-squid-proxy-sa"

}
# ----------------------------------------------------------------------------
# APIs need for the module
# ----------------------------------------------------------------------------
variable "gcp_service_list" {
  description = "List of GCP APIs that are required by the module"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com"
  ]
}