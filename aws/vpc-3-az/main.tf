module "vpc" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/vpc?ref=v1.0.0"
  aws_region = var.aws_region
  stack_name = var.stack_name
  additional_tags = var.additional_tags
  cidr_vpc = var.cidr_vpc
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  create_nat_gateways = var.create_nat_gateways
  nat_gateway_az =var.nat_gateway_az
  nat_routes_for_private_subnets = var.nat_routes_for_private_subnets
  igw_routes_for_public_subnets = var.igw_routes_for_public_subnets
}