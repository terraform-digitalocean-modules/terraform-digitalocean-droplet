output "loadbalancer_ip" {
  description = "IP address of the Load Balancer"
  value       = module.web.loadbalancer_ip
}

output "web_ipv4_address" {
  description = "List of IPv4 addresses of web Droplets"
  value       = module.web.ipv4_address
}
