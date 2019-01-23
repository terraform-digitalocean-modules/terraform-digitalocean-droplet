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
  count = "${var.custom_image > 0 ? 0 : 1}"
  slug  = "${var.image_name}"
}

data "digitalocean_image" "custom" {
  count = "${var.custom_image > 0 ? 1 : 0}"
  name  = "${var.image_name}"
}

resource "digitalocean_tag" "default_tag" {
  count = "${var.droplet_count > 0 ? 1 : 0}"

  name = "DEFAULT:${var.droplet_name}"
}

// Create Droplets
resource "digitalocean_droplet" "droplet" {
  count = "${var.droplet_count}"

  image = "${coalesce(var.image_id, element(coalescelist(data.digitalocean_image.custom.*.image, data.digitalocean_image.official.*.image), 0))}"
  name  = "${format("%s-%s", var.droplet_name, format(var.number_format, count.index+1))}"

  region = "${var.region}"
  size   = "${coalesce(local.sizes[var.droplet_size], var.droplet_size)}"

  // Optional
  backups            = "${var.backups}"
  monitoring         = "${var.monitoring}"
  ipv6               = "${var.ipv6}"
  private_networking = "${var.private_networking}"
  ssh_keys           = "${var.ssh_keys}"
  resize_disk        = "${var.resize_disk}"
  tags               = ["${compact(concat(var.tags, list(digitalocean_tag.default_tag.id)))}"]
  user_data          = "${var.user_data}"
}

// Block storage
resource "digitalocean_volume" "volume" {
  count = "${var.block_storage_size > 0 ? coalesce(var.block_storage_count, var.droplet_count) : 0}"

  region = "${var.region}"
  name   = "${coalesce(var.block_storage_name, element(digitalocean_droplet.droplet.*.name, count.index))}"
  size   = "${var.block_storage_size}"

  // Optional
  description              = "Block storage for ${element(digitalocean_droplet.droplet.*.name, count.index)}"
  initial_filesystem_label = "${var.block_storage_filesystem_label}"
  initial_filesystem_type  = "${var.block_storage_filesystem_type}"
}

// Attach volumes
resource "digitalocean_volume_attachment" "volume_attachment" {
  count = "${var.block_storage_size > 0 && var.block_storage_attach > 0 ? coalesce(var.block_storage_count, var.droplet_count) : 0}"

  droplet_id = "${element(digitalocean_droplet.droplet.*.id, count.index)}"
  volume_id  = "${element(digitalocean_volume.volume.*.id, count.index)}"
}

// Floating IP
resource "digitalocean_floating_ip" "floating_ip" {
  count  = "${var.floating_ip > 0 ? coalesce(var.floating_ip_count, var.droplet_count) : 0}"
  region = "${var.region}"
}

// Floating IP assignment
resource "digitalocean_floating_ip_assignment" "floating_ip_assignment" {
  count = "${var.floating_ip > 0 && var.floating_ip_assign > 0 ? coalesce(var.floating_ip_count, var.droplet_count) : 0}"

  ip_address = "${element(digitalocean_floating_ip.floating_ip.*.id, count.index)}"
  droplet_id = "${element(digitalocean_droplet.droplet.*.id, count.index)}"
}

// Loadbalancer
resource "digitalocean_loadbalancer" "loadbalancer" {
  count = "${var.loadbalancer > 0 ? 1 : 0}"

  name      = "${coalesce(var.loadbalancer_name, format("%s-lb", var.droplet_name))}"
  region    = "${var.region}"
  algorithm = "${var.loadbalancer_algorithm}"

  redirect_http_to_https = "${var.loadbalancer_redirect_http_to_https}"

  forwarding_rule = ["${var.loadbalancer_forwarding_rule}"]
  healthcheck     = ["${var.loadbalancer_healthcheck}"]
  sticky_sessions = ["${var.loadbalancer_sticky_sessions}"]

  droplet_tag = "${digitalocean_tag.default_tag.name}"
}

// Public DNS A Record
resource "digitalocean_record" "public_a" {
  count = "${length(var.public_domain) > 0 ? var.droplet_count : 0}"

  domain = "${var.public_domain}"
  type   = "A"
  name   = "${element(digitalocean_droplet.droplet.*.name, count.index)}"
  value  = "${element(digitalocean_droplet.droplet.*.ipv4_address, count.index)}"
}

// Public DNS AAAA Record
resource "digitalocean_record" "public_aaaa" {
  count = "${length(var.public_domain) > 0 ? var.droplet_count : 0}"

  domain = "${var.public_domain}"
  type   = "AAAA"
  name   = "${element(digitalocean_droplet.droplet.*.name, count.index)}"
  value  = "${element(digitalocean_droplet.droplet.*.ipv6_address, count.index)}"
}

// Private DNS A Record
resource "digitalocean_record" "private_a" {
  count = "${var.private_networking > 0 && length(var.private_domain) > 0 ? var.droplet_count : 0}"

  domain = "${var.private_domain}"
  type   = "A"
  name   = "${element(digitalocean_droplet.droplet.*.name, count.index)}"
  value  = "${element(digitalocean_droplet.droplet.*.ipv4_address_private, count.index)}"
}
