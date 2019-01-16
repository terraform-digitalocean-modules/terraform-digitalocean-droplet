output "db_ids" {
  description = "List of IDs of DB Droplets"
  value       = "${module.db.droplet_id}"
}

output "db_ipv4_address_private" {
  description = "List of IPv4 addresses of DB Droplets"
  value       = "${module.db.ipv4_address_private}"
}

output "db_tags" {
  description = "List of tags of DB Droplets"
  value       = "${module.db.tags}"
}

output "db_volume_attachment_id" {
  description = "List of volume attachment IDs of DB Droplets"
  value       = "${module.db.volume_attachment_id}"
}

output "web_ids" {
  description = "List of IDs of web Droplets"
  value       = "${module.web.droplet_id}"
}

output "web_ipv4_address" {
  description = "List of IPv4 addresses of web Droplets"
  value       = "${module.web.ipv4_address}"
}

output "web_ipv6_address" {
  description = "List of IPv6 addresses of web Droplets"
  value       = "${module.web.ipv6_address}"
}
