variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

// For testing purposes we create a random domain name to prevent clashing
// with other DigitalOcean domains
provider "random" {}

resource "random_string" "domain" {
  length  = 10
  special = false
  upper   = false
}

// Tags
resource "digitalocean_tag" "ENV_example" {
  name = "ENV:example"
}

resource "digitalocean_tag" "ROLE_web" {
  name = "ROLE:web"
}

// DNS Zones
resource "digitalocean_domain" "public" {
  name = format("public.%s.com", random_string.domain.result)
}

resource "digitalocean_record" "public-apex" {
  domain = digitalocean_domain.public.name
  type   = "A"
  name   = "@"
  value  = module.web.loadbalancer_ip
}

module "web" {
  source = "../../"

  droplet_count = 2

  droplet_name = "example-web"
  droplet_size = "nano"
  tags         = [digitalocean_tag.ENV_example.id, digitalocean_tag.ROLE_web.id]
  user_data    = file("user-data.web")

  ipv6          = true
  public_domain = digitalocean_domain.public.name

  loadbalancer = true
}
