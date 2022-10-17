output "ip_address" {
    description= "The proxied IP address"
    value = google_compute_address.squid-public-ip.address
}