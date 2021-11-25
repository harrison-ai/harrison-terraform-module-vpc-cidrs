variable "cidr" {
  type        = string
  description = "CIDR block of the VPC"
  validation {
    condition     = 16 <= element(split("/", var.cidr), length(split("/", var.cidr)) - 1) && 28 >= element(split("/", var.cidr), length(split("/", var.cidr)) - 1)
    error_message = "The VPC prefix must be between /16 and /28 as per https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html."
  }
}

variable "subnet_tiers" {
  type        = list(string)
  description = "List of Subnet tiers or types.  E.G: Public, Private"
}

variable "subnet_prefix" {
  type        = number
  description = "The desired subnet prefix"
}

variable "number_of_azs" {
  type        = number
  description = "The desired subnet prefix"
}
