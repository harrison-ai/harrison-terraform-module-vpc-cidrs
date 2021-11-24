output "tiers" {
  value       = local.tiers
  description = "Map of Subnet Tiers and their associated CIDR blocks"
}

output "subnets" {
  value       = local.subnets
  description = "Map of Lists of Subnets, suitable for entry into a VPC module"
}
