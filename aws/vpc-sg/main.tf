module "vpc" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/vpc?ref=v1.2.5"
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

module "sg_a" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/security-group?ref=v1.2.5"
  name_prefix = "${var.stack_name}-a"
  description = "Example a"
  vpc_id = module.vpc.id

  ingress_from_self_list = var.sg_a_ingress_from_self_list
  ingress_source_sg_list = var.sg_a_ingress_source_sg_list
  ingress_cidr_list = var.sg_a_ingress_cidr_list
  ingress_ipv6_cidr_list = var.sg_a_ingress_ipv6_cidr_list
  ingress_prefix_list_ids = var.sg_a_ingress_prefix_list_ids

  egress_source_sg_list = var.sg_a_egress_source_sg_list
  egress_cidr_list = var.sg_a_egress_cidr_list
  egress_ipv6_cidr_list = var.sg_a_egress_ipv6_cidr_list
  egress_prefix_list_ids = var.sg_a_egress_prefix_list_ids

  stack_name = var.stack_name
  additional_tags = var.additional_tags
}

module "sg_b" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/security-group?ref=v1.2.5"
  name_prefix = "${var.stack_name}-b"
  description = "Example b"
  vpc_id = module.vpc.id

  ingress_from_self_list = var.sg_b_ingress_from_self_list
  ingress_cidr_list = var.sg_b_ingress_cidr_list

  stack_name = var.stack_name
  additional_tags = var.additional_tags
}

module "sg_c" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/security-group?ref=v1.2.5"
  name_prefix = "${var.stack_name}-c"
  description = "Example c"
  vpc_id = module.vpc.id

  ingress_source_sg_list = [ 
    join(",", ["0", "0", "-1", module.sg_a.id, "Allow all traffic from a"]),
    join(",", ["443", "443", "tcp", module.sg_b.id, "Allow HTTPS traffic from b"])
  ]
  egress_source_sg_list = [ 
    join(",", ["0", "0", "-1", module.sg_a.id, "Allow all traffic to a"]),
    join(",", ["0", "0", "-1", module.sg_b.id, "Allow all traffic to b"])
  ]
  egress_cidr_list = []
  stack_name = var.stack_name
  additional_tags = var.additional_tags
}