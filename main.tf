// Lookup image to get id
data "digitalocean_image" "default" {
  name = "${var.custom_image == 1 ? var.image_name : ""}"
  slug = "${var.custom_image == 1 ? "" : var.image_name}"
}

// Create Droplets
resource "digitalocean_droplet" "droplet" {
  count = "${var.number_of_droplets}"

  image = "${coalesce(var.image_id, data.digitalocean_image.default.image)}"
  name  = "${var.domain_external != "" ? format("%s-%d.%s", var.droplet_name, format(var.number_format, count.index+1), var.domain_external) : format("%s-%d", var.droplet_name, format(var.number_format, count.index+1))}"

  region = "${var.region}"
  size   = "${coalesce(var.sizes[var.droplet_size], var.droplet_size)}"

  // Optional
  backups            = "${var.backups}"
  monitoring         = "${var.monitoring}"
  ipv6               = "${var.ipv6}"
  private_networking = "${var.private_networking}"
  ssh_keys           = "${var.ssh_keys}"
  resize_disk        = "${var.resize_disk}"
  tags               = "${var.tags}"
  user_data          = "${var.user_data}"
  volume_ids         = "${var.volume_ids}"
}

// Block storage
resource "digitalocean_volume" "volume" {
  count = "${var.block_storage_size > 0 ? var.number_of_droplets : 0}"

  region = "${var.region}"
  name   = "${format("%s-%d", var.droplet_name, format(var.number_format, count.index+1))}"
  size   = "${var.block_storage_size}"

  // Optional
  description              = "Block storage for ${format("%s-%d", var.droplet_name, format(var.number_format, count.index+1))}"
  snapshot_id              = "${var.block_storage_snapshot_id}"
  initial_filesystem_type  = "${var.block_storage_filesystem_type}"
  initial_filesystem_label = "${var.block_storage_filesystem_label}"
}

// Attach volumes
resource "digitalocean_volume_attachment" "volume_attachment" {
  count = "${var.block_storage_size > 0 ? var.number_of_droplets : 0}"

  droplet_id = "${element(digitalocean_droplet.droplet.*.id, count.index)}"
  volume_id  = "${element(digitalocean_volume.volume.*.id, count.index)}"
}
