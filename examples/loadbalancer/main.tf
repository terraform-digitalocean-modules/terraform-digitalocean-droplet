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

  droplet_count = 2

  droplet_name = "example-web"
  droplet_size = "nano"
  tags         = [digitalocean_tag.ENV_example.id, digitalocean_tag.ROLE_web.id]
  user_data    = file("user-data.web")

  loadbalancer = true
}
