locals {

  # map the number of AZ's to the number of subnet newbits required
  az_prefix_map = {
    1 = 0
    2 = 1
    3 = 2
    4 = 2
    5 = 3
    6 = 3
    7 = 3
    8 = 3
  }

  # obtain the VPC CIDR block network prefix
  cidr_prefix = element(split("/", var.cidr), length(split("/", var.cidr)) - 1)

  # Calculate how large the subnet tiers need to be to accomodate the number of AZ's
  subnet_newbits = lookup(local.az_prefix_map, var.number_of_azs)

  # Calculate the subnet tier newbits, given the desired subnet size.
  tier_newbits = var.subnet_prefix - local.subnet_newbits - local.cidr_prefix

  # Calculate the tier supernets
  tiers = { for tier in var.subnet_tiers : tier => cidrsubnet(var.cidr, local.tier_newbits, index(var.subnet_tiers, tier)) }

  # Calculate the individual subnets
  subnets = { for k, v in local.tiers : k =>
    [for az in range(var.number_of_azs) : cidrsubnet(v, local.subnet_newbits, az)]
  }
}
