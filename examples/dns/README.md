# DNS example

An example of provisioning Droplets attached to a Load Balancer using tags and
configuring DNS zones and records for droplets and the loadbalancer.


## Usage

>**Caveat** due to a long standing limitation in using computed values within
count variable assignment you need to target the public domain creation before
creating the other resources. This shouldn't be a problem in normal usage and is
because this example uses the random provider to generate a random domain name.

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -target=digitalocean_domain.public
$ terraform apply -target=digitalocean_domain.public
$ terraform plan
$ terraform apply
```

This is due to the domain already existing on DigitalOcean. You can swap these
lines to generate a random domain name:

Now visit your Load Balancer IP in a browser and refresh. After a few minutes
you should see the requests are sent to each Droplet in a round-robin fashion.

**Note** DNS records will not be propagated to the internet (so won't resolve)
until you have updated your NS records with your registrar. For testing purposes
you can resolve addresses by targeting a DigitalOcean Name Server with dig.
Example:

```
dig `terraform output -json public_hostnames | jq -r .value[0]` @ns1.digitalocean.com
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
| loadbalancer\_ip | IP address of the Load Balancer. |
| public\_domain\_name | The public DNS domain name. |
| public\_hostnames | The public domain name of the first Droplet. |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets. |
| web\_ipv6\_address | List of IPv6 addresses of web Droplets. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
