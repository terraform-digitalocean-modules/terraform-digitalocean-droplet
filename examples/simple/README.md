# Simple example

A simple example of provisioning droplets with and without attached storage.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money.
Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| do\_token | - | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_ids | List of IDs of DB Droplets |
| db\_ipv4\_address\_private | List of IPv4 addresses of db Droplets |
| db\_tags | List of tags of DB Droplets |
| db\_volume\_attachment\_id | List of volume attachment IDs of DB Droplets |
| web\_ids | List of IDs of web Droplets |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets |
| web\_ipv6\_address | List of IPv6 addresses of web Droplets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
