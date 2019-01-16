# Loadbalancer example

An example of provisioning Droplets attached to a Load Balancer using tags.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Now visit your Load Balancer IP in a browser and refresh. You should see the
requests are sent to each Droplet.

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
| loadbalancer\_ip | IP address of the Load Balancer |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
