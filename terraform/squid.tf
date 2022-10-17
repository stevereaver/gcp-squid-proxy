#-------------------------------------------------------
# iap-squid-proxy
#-------------------------------------------------------

locals {
  squid_conf = <<EOF
acl iapnet src 35.235.240.0/20
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 22          # ssh
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow iapnet
http_access deny all
http_port 3128
include /etc/squid/conf.d/*
coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims
refresh_pattern \/InRelease$ 0 0% 0 refresh-ims
refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern .               0       20%     4320
  EOF

  ops_agent = <<EOF
logging:
  receivers:
    squid:
      type: files
      include_paths:
              - /var/log/squid/access.log
              - /var/log/squid/error.log
  service:
    pipelines:
      default_pipeline:
        receivers: 
          - squid
  EOF

  startup_script = <<EOF
#!/bin/bash
apt update
apt -yq upgrade
apt -yq install squid
echo "${local.squid_conf}" > /etc/squid/squid.conf
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install
echo "${local.ops_agent}" >  /etc/google-cloud-ops-agent/config.yaml
systemctl restart google-cloud-ops-agent 
systemctl restart squid
  EOF
}

#-------------------------------------------------------
# iap-squid-proxy VM Instance
#-------------------------------------------------------

resource "google_compute_instance" "iap_squid_proxy" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  metadata_startup_script = local.startup_script

  network_interface {
    network = var.network
  }


  tags = var.network_tag

  service_account {
    email  = google_service_account.iap_squid_proxy_sa.email
    scopes = ["cloud-platform"]
  }
}