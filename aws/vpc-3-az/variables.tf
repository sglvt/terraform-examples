variable "aws_profile" {
  type = string
  description = "AWS profile to use"
}
variable "aws_region" {
  type = string
  description = "AWS region to use"
}

variable "stack_name" {
  type = string
  description = "Stack name"
}


variable "cidr_vpc" {
  type = string
  description = "The CIDR block of the VPC"
}

variable "public_subnets" {
  type    = map(string)
  description = "Map of availability zones and CIDR blocks of public subnets"
}

variable "private_subnets" {
  type    = map(string)
  description = "Map of availability zones and CIDR blocks of private subnets"
}

variable "create_nat_gateways" {
  type = bool
  description = "Flag which determines whether NAT gateways will be created in public subnets"
}

variable "nat_gateway_az" {
  type    = list(string)
  description = "List of availability zones where NAT gateways should be created"
}

variable "additional_tags" {
  type    = map(string)
  description = "Additional tags to be added"
}

variable "igw_routes_for_public_subnets" {
  type    = list(string)
  description = "Public Subnets - Destination CIDRs for routes passing through the NAT gateways"
}

variable "nat_routes_for_private_subnets" {
  type    = list(string)
  description = "Private Subnets - Destination CIDRs for routes passing through the NAT gateways"
}