variable "backups" {
  description = "(Optional) Boolean controlling if backups are made. Defaults to false."
  default     = false
}

variable "block_storage_attach" {
  description = "(Optional) Whether to attach the volume using Terraform or not."
  default     = true
}

variable "block_storage_count" {
  description = "(Optional) A count of block storage volume resources to create."
  default     = ""
}

variable "block_storage_filesystem_label" {
  description = "(Optional) Initial filesystem label for the block storage volume."
  default     = "data"
}

variable "block_storage_filesystem_type" {
  description = "(Optional) Initial filesystem type (xfs or ext4) for the block storage volume."
  default     = "xfs"
}

variable "block_storage_name" {
  description = "(Optional) Override filesystem name for the block storage volume."
  default     = ""
}

variable "block_storage_size" {
  description = "(Required) The size of the block storage volume in GiB. If updated, can only be expanded."
  default     = 0
}

variable "custom_image" {
  description = "Whether the image is custom or not (an official image)"
  default     = false
}

variable "droplet_count" {
  description = "The number of droplets / other resources to create"
  default     = 1
}

variable "droplet_name" {
  description = "The name of the droplet. If more than one droplet it is appended with the count, examples: stg-web, stg-web-01, stg-web-02"
}

variable "droplet_size" {
  description = "the size slug of a droplet size"
  default     = "micro"
}

variable "floating_ip" {
  description = "(Optional) Boolean to control whether floating IPs should be created."
  default     = false
}

variable "floating_ip_assign" {
  description = "(Optional) Boolean controlling whether floatin IPs should be assigned to instances with Terraform."
  default     = true
}

variable "floating_ip_count" {
  description = "Number of floating IPs to create."
  default     = ""
}

variable "image_id" {
  description = "The id of an image to use."
  default     = ""
}

variable "image_name" {
  description = "The image name or slug to lookup."
  default     = "ubuntu-18-04-x64"
}

variable "ipv6" {
  description = "(Optional) Boolean controlling if IPv6 is enabled. Defaults to false."
  default     = false
}

variable "loadbalancer" {
  description = "Boolean to control whether to create a Load Balancer."
  default     = false
}

variable "loadbalancer_algorithm" {
  description = "The load balancing algorithm used to determine which backend Droplet will be selected by a client. It must be either round_robin or least_connections."
  default     = "round_robin"
}

variable "loadbalancer_forwarding_rule" {
  description = "List of forwarding_rule maps to apply to the loadbalancer."

  default = {
    entry_port      = 80
    entry_protocol  = "http"
    target_port     = 80
    target_protocol = "http"
    tls_passthrough = false
  }
}

variable "loadbalancer_healthcheck" {
  description = "A healthcheck block to be assigned to the Load Balancer. Only 1 healthcheck is allowed."

  default = {
    port                     = 80
    protocol                 = "http"
    path                     = "/"
    check_interval_seconds   = 10
    response_timeout_seconds = 10
    unhealthy_threshold      = 3
    healthy_threshold        = 5
  }
}

variable "loadbalancer_name" {
  description = "Override Load Balancer name."
  default     = ""
}

variable "loadbalancer_redirect_http_to_https" {
  description = "(Optional) A boolean value indicating whether HTTP requests to the Load Balancer on port 80 will be redirected to HTTPS on port 443."
  default     = false
}

variable "loadbalancer_sticky_sessions" {
  description = "A sticky_sessions block to be assigned to the Load Balancer. Only 1 sticky_sessions block is allowed."
  default = {
    type               = "none"
    cookie_name        = null
    cookie_ttl_seconds = null
  }
}

variable "loadbalancer_tag" {
  description = "The name of a Droplet tag corresponding to Droplets to be assigned to the Load Balancer."
  default     = ""
}

variable "monitoring" {
  description = "(Optional) Boolean controlling whether monitoring agent is installed. Defaults to false."
  default     = false
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}

variable "private_networking" {
  description = "(Optional) Boolean controlling if private networks are enabled. Defaults to false."
  default     = false
}

variable "region" {
  description = "The Digitalocean datacenter to create resources in."
  default     = "ams3"
}

variable "resize_disk" {
  description = "(Optional) Boolean controlling whether to increase the disk size when resizing a Droplet. It defaults to true. When set to false, only the Droplet's RAM and CPU will be resized. Increasing a Droplet's disk size is a permanent change. Increasing only RAM and CPU is reversible."
  default     = true
}

variable "ssh_keys" {
  description = "(Optional) A list of SSH IDs or fingerprints to enable in the format [12345, 123456]. To retrieve this info, use a tool such as curl with the DigitalOcean API, to retrieve them."
  default     = []
}

variable "tags" {
  description = "(Optional) A list of the tags to label this Droplet. A tag resource must exist before it can be associated with a Droplet."
  default     = []
}

variable "user_data" {
  description = "(Optional) A string of the desired User Data for the Droplet."
  default     = "exit 0"
}

variable "public_domain" {
  description = "(Optional) String containing the public DNS domain to create a record for the Droplets in."
  default     = ""
}

variable "private_domain" {
  description = "(Optional) String containing the private DNS domain to create a record for the Droplets in."
  default     = ""
}
