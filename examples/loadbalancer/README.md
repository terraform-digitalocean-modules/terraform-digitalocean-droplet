# Loadbalancer example

An example of provisioning Droplets attached to a Load Balancer using tags.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Now visit your Load Balancer IP in a browser and refresh. After a few minutes
you should see the requests are sent to each Droplet in a round-robin fashion.

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
| loadbalancer\_ip | IP address of the Load Balancer |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
