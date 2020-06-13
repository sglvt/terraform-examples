module "vpc" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/vpc?ref=v1.2.1"
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

module "sg_demo" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/security-group?ref=v1.2.1"
  name_prefix = "${var.stack_name}-example"
  description = "Example Security Group"
  vpc_id = module.vpc.id
  tcp_ingress = var.sg_demo_tcp_ingress
  udp_ingress = var.sg_demo_udp_ingress
  any_ingress = var.sg_demo_any_ingress

  tcp_egress= var.sg_demo_tcp_egress
  udp_egress= var.sg_demo_udp_egress
  any_egress = var.sg_demo_any_egress
  stack_name = var.stack_name
  additional_tags = var.additional_tags
}