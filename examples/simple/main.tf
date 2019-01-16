variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_tag" "ENV_example" {
  name = "ENV:example"
}

resource "digitalocean_tag" "ROLE_web" {
  name = "ROLE:web"
}

resource "digitalocean_tag" "ROLE_db" {
  name = "ROLE:db"
}

module "web" {
  source = "../../"

  droplet_count = 2

  droplet_name       = "example-web"
  droplet_size       = "nano"
  monitoring         = true
  private_networking = true
  ipv6               = true
  tags               = ["${digitalocean_tag.ENV_example.id}", "${digitalocean_tag.ROLE_web.id}"]
}

module "db" {
  source = "../../"

  droplet_count = 1

  droplet_name       = "example-db"
  droplet_size       = "nano"
  monitoring         = true
  private_networking = true
  ipv6               = true
  block_storage_size = 5
  tags               = ["${digitalocean_tag.ENV_example.id}", "${digitalocean_tag.ROLE_db.id}"]
}
