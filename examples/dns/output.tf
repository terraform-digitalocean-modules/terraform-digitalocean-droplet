output "loadbalancer_ip" {
  description = "IP address of the Load Balancer."
  value       = "${module.web.loadbalancer_ip}"
}

output "web_ipv4_address" {
  description = "List of IPv4 addresses of web Droplets."
  value       = "${module.web.ipv4_address}"
}

output "public_domain_name" {
  description = "The public DNS domain name."
  value       = "${digitalocean_domain.public.name}"
}

output "public_domain_ip_address" {
  description = "The public DNS domain apex record IP address."
  value       = "${digitalocean_domain.public.ip_address}"
}

output "private_domain_zone_file" {
  description = "The private DNS domain zone file contents."
  value       = "${data.digitalocean_domain.private.zone_file}"
}

output "public_hostnames" {
  description = "The public domain name of the first Droplet."
  value       = "${module.web.public_a}"
}
