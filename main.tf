locals {
  // Map of pre-named sizes to look up from
  sizes = {
    nano      = "s-1vcpu-1gb"
    micro     = "s-2vcpu-2gb"
    small     = "s-2vcpu-4gb"
    medium    = "s-4vcpu-8gb"
    large     = "s-6vcpu-16gb"
    x-large   = "s-8vcpu-32gb"
    xx-large  = "s-16vcpu-64gb"
    xxx-large = "s-24vcpu-128gb"
    maximum   = "s-32vcpu-192gb"
  }
}

// Lookup image to get id
data "digitalocean_image" "official" {
  count = var.custom_image == true ? 0 : 1
  slug  = var.image_name
}

data "digitalocean_image" "custom" {
  count = var.custom_image == true ? 1 : 0
  name  = var.image_name
}

resource "digitalocean_tag" "default_tag" {
  count = var.droplet_count > 0 ? 1 : 0

  name = "DEFAULT:${var.droplet_name}"
}

// Create Droplets
resource "digitalocean_droplet" "droplet" {
  count = var.droplet_count

  image = coalesce(var.image_id, element(coalescelist(data.digitalocean_image.custom.*.image, data.digitalocean_image.official.*.image), 0))
  name  = format("%s-%s", var.droplet_name, format(var.number_format, count.index + 1))

  region = var.region
  size   = coalesce(local.sizes[var.droplet_size], var.droplet_size)

  // Optional
  backups            = var.backups
  monitoring         = var.monitoring
  ipv6               = var.ipv6
  private_networking = var.private_networking
  ssh_keys           = var.ssh_keys
  resize_disk        = var.resize_disk
  tags               = compact(concat(var.tags, digitalocean_tag.default_tag.*.name, list("")))
  user_data          = var.user_data
}
// Block storage
resource "digitalocean_volume" "volume" {
  count = var.block_storage_size > 0 ? coalesce(var.block_storage_count, var.droplet_count) : 0

  region = var.region
  name   = coalesce(var.block_storage_name, element(digitalocean_droplet.droplet.*.name, count.index))
  size   = var.block_storage_size

  // Optional
  description              = "Block storage for ${element(digitalocean_droplet.droplet.*.name, count.index)}"
  initial_filesystem_label = var.block_storage_filesystem_label
  initial_filesystem_type  = var.block_storage_filesystem_type
}

// Attach volumes
resource "digitalocean_volume_attachment" "volume_attachment" {
  count = var.block_storage_size > 0 && var.block_storage_attach == true ? coalesce(var.block_storage_count, var.droplet_count) : 0

  droplet_id = element(digitalocean_droplet.droplet.*.id, count.index)
  volume_id  = element(digitalocean_volume.volume.*.id, count.index)
}

// Floating IP
resource "digitalocean_floating_ip" "floating_ip" {
  count  = var.floating_ip == true && var.droplet_count > 0 ? coalesce(var.floating_ip_count, var.droplet_count) : 0
  region = var.region
}

// Floating IP assignment
resource "digitalocean_floating_ip_assignment" "floating_ip_assignment" {
  depends_on = [digitalocean_droplet.droplet]
  count      = var.floating_ip == true && var.floating_ip_assign == true && var.droplet_count > 0 ? coalesce(var.floating_ip_count, var.droplet_count) : 0

  ip_address = element(digitalocean_floating_ip.floating_ip.*.id, count.index)
  droplet_id = element(digitalocean_droplet.droplet.*.id, count.index)
}

// Loadbalancer
resource "digitalocean_loadbalancer" "loadbalancer" {
  count = var.loadbalancer == true && var.droplet_count > 0 ? 1 : 0

  name      = coalesce(var.loadbalancer_name, format("%s-lb", var.droplet_name))
  region    = var.region
  algorithm = var.loadbalancer_algorithm

  redirect_http_to_https = var.loadbalancer_redirect_http_to_https
  forwarding_rule {
    entry_port      = lookup(var.loadbalancer_forwarding_rule, "entry_port")
    entry_protocol  = lookup(var.loadbalancer_forwarding_rule, "entry_protocol")
    target_port     = lookup(var.loadbalancer_forwarding_rule, "target_port")
    target_protocol = lookup(var.loadbalancer_forwarding_rule, "target_protocol")
    tls_passthrough = lookup(var.loadbalancer_forwarding_rule, "tls_passthrough")
  }
  healthcheck {
    protocol                 = lookup(var.loadbalancer_healthcheck, "protocol")
    port                     = lookup(var.loadbalancer_healthcheck, "port")
    path                     = lookup(var.loadbalancer_healthcheck, "path")
    check_interval_seconds   = lookup(var.loadbalancer_healthcheck, "check_interval_seconds")
    response_timeout_seconds = lookup(var.loadbalancer_healthcheck, "response_timeout_seconds")
    unhealthy_threshold      = lookup(var.loadbalancer_healthcheck, "unhealthy_threshold")
    healthy_threshold        = lookup(var.loadbalancer_healthcheck, "healthy_threshold")
  }
  sticky_sessions {
    type               = lookup(var.loadbalancer_sticky_sessions, "type")
    cookie_name        = lookup(var.loadbalancer_sticky_sessions, "cookie_name")
    cookie_ttl_seconds = lookup(var.loadbalancer_sticky_sessions, "cookie_ttl_seconds")
  }

  droplet_tag = element(digitalocean_tag.default_tag.*.name, count.index)
}

// Public DNS A Record
resource "digitalocean_record" "public_a" {
  count = length(var.public_domain) > 0 ? var.droplet_count : 0

  domain = var.public_domain
  type   = "A"
  ttl    = 60
  name   = element(digitalocean_droplet.droplet.*.name, count.index)
  value  = element(digitalocean_droplet.droplet.*.ipv4_address, count.index)
}

// Public DNS AAAA Record
resource "digitalocean_record" "public_aaaa" {
  count = length(var.public_domain) > 0 ? var.droplet_count : 0

  domain = var.public_domain
  type   = "AAAA"
  ttl    = 60
  name   = element(digitalocean_droplet.droplet.*.name, count.index)
  value  = element(digitalocean_droplet.droplet.*.ipv6_address, count.index)
}

// Private DNS A Record
resource "digitalocean_record" "private_a" {
  count = var.private_networking == true && length(var.private_domain) > 0 ? var.droplet_count : 0

  domain = var.private_domain
  type   = "A"
  ttl    = 60
  name   = element(digitalocean_droplet.droplet.*.name, count.index)
  value  = element(digitalocean_droplet.droplet.*.ipv4_address_private, count.index)
}
