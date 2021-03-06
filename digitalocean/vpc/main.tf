resource "digitalocean_vpc" "example" {
  name   = "example"
  region = "sgp1"
  ip_range = "10.0.0.0/16"
}