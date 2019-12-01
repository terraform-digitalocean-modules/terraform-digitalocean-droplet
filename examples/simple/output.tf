output "web_ids" {
  description = "List of IDs of web Droplets"
  value       = module.web.droplet_id
}

output "web_ipv4_address" {
  description = "List of IPv4 addresses of web Droplets"
  value       = module.web.ipv4_address
}

output "web_ipv6_address" {
  description = "List of IPv6 addresses of web Droplets"
  value       = module.web.ipv6_address
}

output "web_tags" {
  description = "List of tags of web Droplets"
  value       = module.web.tags
}

output "web_volume_attachment_id" {
  description = "List of volume attachment IDs of web Droplets"
  value       = module.web.volume_attachment_id
}

output "web_floating_ip_address" {
  description = "List of floating IP addresses of web Droplets"
  value       = module.web.floating_ip_address
}
