variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_tag" "ENV_example" {
  name = "ENV:example"
}

resource "digitalocean_tag" "ROLE_web" {
  name = "ROLE:web"
}

module "web" {
  source = "../../"

  droplet_count = 1

  droplet_name       = "example-web"
  droplet_size       = "nano"
  monitoring         = true
  private_networking = true
  ipv6               = true
  floating_ip        = true
  block_storage_size = 5
  tags               = [digitalocean_tag.ENV_example.id, digitalocean_tag.ROLE_web.id]
  user_data          = file("user-data.web")
}
