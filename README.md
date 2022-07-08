# A Terraform Module to calculate VPC CIDR Blocks

The [Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) that is used for deploying VPC's requires a number of CIDR blocks as inputs for the various subnet types.  This is typically a time consuming manual process, and can be error prone.  This module performs the subnet calculations, based on a small number of input variables.


## Design Considerations

This module has been designed with the following design principles or concepts in mind:


### VPC CIDR Block

This is the CIDR block or range of the entire VPC; anything from a `/16` to a `/28` subnet.


### Subnet Tier

This is the term used to refer to the different "tiers" or "classes" of subnets within a VPC. As examples, taken from the abovementioned VPC module:
- Public
- Private
- Intra

Each Subnet Tier is a CIDR subnet, sized to contain a subnet in each desired Availability Zone.  By way of example, should you require a `/24` subnet in 3 x Availability Zones, then each Subnet Tier will be sized to a `/22`.  A `/22` subnet can contain up to four `/24` subnets.


### Subnet

Subnets are deployed into each of the required Availability Zones, in each of the required Subnet Tiers.


### Complete Example

You require a VPC in the `ap-southeast-2` region, with Public and Private subnets in 3 x Availability Zones.  The VPC CIDR block is `10.0.0.0/16`, and you require the subnets to have a prefix of `/24`


| Subnet Tier | CIDR |
| --- | --- |
| Public | 10.0.0.0/22 |
| Private | 10.0.4.0/22 |


| Subnet | AZ | CIDR |
| --- | --- | --- |
| public-apse-2a | ap-southeast-2a | 10.0.0.0/24 |
| public-apse-2b | ap-southeast-2b | 10.0.1.0/24 |
| public-apse-2c | ap-southeast-2c | 10.0.2.0/24 |
| private-apse-2a | ap-southeast-2a | 10.0.4.0/24 |
| private-apse-2b | ap-southeast-2b | 10.0.5.0/24 |
| private-apse-2c | ap-southeast-2c | 10.0.6.0/24 |


### Usage

```terraform
module "cidr" {
  source = ""

  cidr = "10.0.0.0/16"
  number_of_azs = 3
  subnet_tiers = [
    "public",
    "private",
    "intra"
  ]
  subnet_prefix = 24
}
```

Will return:

```terraform
subnets = {
  intra = [
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24",
  ]
  private = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
  ]
  public = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
tiers = {
  intra   = "10.0.8.0/22"
  private = "10.0.4.0/22"
  public  = "10.0.0.0/22"
}
```

These values can be plugged into the VPC module as follows:

```terraform
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr            = "10.0.0.0/16"
  private_subnets = module.cidr.subnets.private
  public_subnets  = module.cidr.subnets.public
  intra_subnets   = module.cidr.subnets.intra

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_number_of_azs"></a> [number\_of\_azs](#input\_number\_of\_azs) | The desired subnet prefix | `number` | n/a | yes |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | The desired subnet prefix | `number` | n/a | yes |
| <a name="input_subnet_tiers"></a> [subnet\_tiers](#input\_subnet\_tiers) | List of Subnet tiers or types.  E.G: Public, Private | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of Lists of Subnets, suitable for entry into a VPC module |
| <a name="output_tiers"></a> [tiers](#output\_tiers) | Map of Subnet Tiers and their associated CIDR blocks |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## About harrison.ai

This module is maintained by the Data Engineering team at [harrison.ai](https://harrison.ai).

At [harrison.ai](https://harrison.ai) our mission is to create AI-as-a-medical-device solutions through ventures and ultimately improve the standard of healthcare for 1 million lives every day.


## License

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Copyright 2022 harrison.ai Pty. Ltd.
