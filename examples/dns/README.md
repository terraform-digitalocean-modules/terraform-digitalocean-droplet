# DNS example

An example of provisioning Droplets attached to a Load Balancer using tags and
configuring DNS zones and records for droplets and the loadbalancer.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Now visit your Load Balancer IP in a browser and refresh. After a few minutes
you should see the requests are sent to each Droplet in a round-robin fashion.

You can lookup a DNS record like:
```
dig `terraform output -json public_hostnames | jq -r .value[0]` @ns1.digitalocean.com
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
| loadbalancer\_ip | IP address of the Load Balancer. |
| private\_domain\_zone\_file | The private DNS domain zone file contents. |
| public\_domain\_ip\_address | The public DNS domain apex record IP address. |
| public\_domain\_name | The public DNS domain name. |
| public\_hostnames | The public domain name of the first Droplet. |
| web\_ipv4\_address | List of IPv4 addresses of web Droplets. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
