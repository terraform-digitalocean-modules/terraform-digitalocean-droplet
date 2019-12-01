output "loadbalancer_ip" {
  description = "IP address of the Load Balancer."
  value       = module.web.loadbalancer_ip
}

output "web_ipv4_address" {
  description = "List of IPv4 addresses of web Droplets."
  value       = module.web.ipv4_address
}

output "web_ipv6_address" {
  description = "List of IPv6 addresses of web Droplets."
  value       = module.web.ipv6_address
}

output "public_domain_name" {
  description = "The public DNS domain name."
  value       = digitalocean_domain.public.name
}

output "public_hostnames" {
  description = "The public domain name of the first Droplet."
  value       = module.web.public_a
}
