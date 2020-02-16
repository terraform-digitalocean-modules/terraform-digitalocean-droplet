# Simple example

A simple example of provisioning droplets with a floating IP and attached storage.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

**Note** that this example may create resources which can cost money.
Run `terraform destroy` when you don't need these resources.

If you're looking to try Digitalocean out, [sign up here](https://m.do.co/c/485f1b80f8dc)
and get $100 free credit.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| do\_token |  | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| web\_floating\_ip\_address | List of floating IP addresses of web Droplets |
| web\_ids | List of IDs of web Droplets |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets |
| web\_ipv6\_address | List of IPv6 addresses of web Droplets |
| web\_tags | List of tags of web Droplets |
| web\_volume\_attachment\_id | List of volume attachment IDs of web Droplets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
