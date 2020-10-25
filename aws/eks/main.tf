# VPC

module "vpc" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/vpc?ref=v1.3.2"
  aws_region = var.aws_region
  stack_name = var.stack_name
  additional_tags = merge({
    "kubernetes.io/cluster/${var.stack_name}-${var.eks_cluster_name}" = "shared"
    stack_name = var.stack_name
  }, var.additional_tags)
  cidr_vpc = var.cidr_vpc
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  create_nat_gateways = var.create_nat_gateways
  nat_gateway_az =var.nat_gateway_az
  nat_routes_for_private_subnets = var.nat_routes_for_private_subnets
  igw_routes_for_public_subnets = var.igw_routes_for_public_subnets
}

# Security Groups

## SG - EKS 

resource "aws_security_group" "sg_eks_node" {
  name_prefix = "${var.stack_name}-eks-node"
  description = "EKS Node"
  vpc_id = module.vpc.id

  tags = merge({
    Name = "${var.stack_name}-eks-node"
    stack_name = var.stack_name
    "kubernetes.io/cluster/${var.stack_name}-${var.eks_cluster_name}" = "shared"
  }, var.additional_tags)
}

## SG - EKS Control Plane

module "sg_eks_cp" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/security-group?ref=v1.3.2"
  name_prefix = "${var.stack_name}-eks-cp"
  description = "EKS Control Plane"
  vpc_id = module.vpc.id

  ingress_cidr_list = []
  ingress_from_self_list = [ "0,0,-1,Allow all traffic from self" ]
  ingress_source_sg_list = [ 
    join(",", ["443", "443", "tcp", aws_security_group.sg_eks_node.id, "Allow HTTPS traffic from sg_eks_node"])
  ]

  egress_cidr_list = [ "0,0,-1,0.0.0.0/0,Allow any" ]

  stack_name = var.stack_name
  additional_tags = merge({
    Name = "${var.stack_name}-eks-cp"
    stack_name = var.stack_name
    "kubernetes.io/cluster/${var.stack_name}-${var.eks_cluster_name}" = "shared"
  }, var.additional_tags)
}

## Ingress rules declared separately because of circular dependency

resource "aws_security_group_rule" "sg_eks_node_ingress_allow_1025_65535_from_cp" {
  type = "ingress"
  from_port = 1025
  to_port = 65535
  protocol = "tcp"
  description = "Allow TCP 1025-65535 traffic from EKS control plane"
  security_group_id = aws_security_group.sg_eks_node.id
  source_security_group_id = module.sg_eks_cp.id
}

resource "aws_security_group_rule" "sg_eks_node_ingress_allow_443_from_cp" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  description = "Allow HTTPS traffic from EKS control plane"
  security_group_id = aws_security_group.sg_eks_node.id
  source_security_group_id = module.sg_eks_cp.id
}

resource "aws_security_group_rule" "sg_eks_node_ingress_allow_1025_65535_from_self" {
  type = "ingress"
  from_port = 1025
  to_port = 65535
  protocol = "tcp"
  description = "Allow TCP 1025-65535 traffic from self"
  security_group_id = aws_security_group.sg_eks_node.id
  self = true
}

resource "aws_security_group_rule" "sg_eks_node_ingress_allow_443_from_self" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  description = "Allow HTTPS traffic from self"
  security_group_id = aws_security_group.sg_eks_node.id
  self = true
}

resource "aws_security_group_rule" "sg_eks_node_ingress_allow_53_from_self" {
  type = "ingress"
  from_port = 53
  to_port = 53
  protocol = "udp"
  description = "Allow UDP 53 traffic from self"
  security_group_id = aws_security_group.sg_eks_node.id
  self = true
}

resource "aws_security_group_rule" "sg_eks_node_egress_allow_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  description = "Allow all traffic"
  security_group_id = aws_security_group.sg_eks_node.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

# IAM

resource "aws_iam_role" "eks_cluster_role" {

  name_prefix = "${var.stack_name}-eks-cp"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_cluster_role.name
}

# EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.stack_name}-${var.eks_cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = var.eks_version

  enabled_cluster_log_types = var.eks_enabled_cluster_log_types

  vpc_config {
    subnet_ids = module.vpc.public_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access = var.eks_endpoint_public_access
    security_group_ids = [ module.sg_eks_cp.id ]
    public_access_cidrs = var.eks_public_access_cidrs
  }

  depends_on = [
    aws_iam_role.eks_cluster_role
  ]
}

module "eks_node_group_1" {
  source = "git::https://github.com/serbangilvitu/terraform-modules.git//aws/eks-node-group?ref=v1.3.2"
  cluster_name = "${var.stack_name}-${var.eks_cluster_name}"
  eks_version = var.eks_version
  subnet_ids = module.vpc.public_subnet_ids
  instance_type = var.eks_node_group_1_instance_type
  endpoint = aws_eks_cluster.eks_cluster.endpoint
  max_size = var.eks_node_group_1_max_size
  min_size = var.eks_node_group_1_min_size
  security_groups = list(aws_security_group.sg_eks_node.id)
  associate_public_ip_address = var.eks_node_group_1_associate_public_ip_address
  key_name = var.eks_node_group_1_key_name
  ebs_optimized = var.eks_node_group_1_ebs_optimized
  cluster_auth_base64 = aws_eks_cluster.eks_cluster.certificate_authority.0.data

  on_demand_base_capacity = var.eks_node_group_1_on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.eks_node_group_1_on_demand_percentage_above_base_capacity
  spot_allocation_strategy = var.eks_node_group_1_spot_allocation_strategy
  spot_instance_pools = var.eks_node_group_1_spot_instance_pools
  spot_max_price = var.eks_node_group_1_spot_max_price

  pre_userdata = var.eks_node_group_1_pre_userdata
  bootstrap_extra_args = var.eks_node_group_1_bootstrap_extra_args
  kubelet_extra_args = var.eks_node_group_1_kubelet_extra_args
  additional_userdata = var.eks_node_group_1_additional_userdata

  stack_name = var.stack_name
  additional_tags = merge({
    Name = "${var.stack_name}-${var.eks_cluster_name}-group-1"
    "kubernetes.io/cluster/${var.stack_name}-${var.eks_cluster_name}" = "shared"
    "k8s.io/cluster-autoscaler/${var.stack_name}-${var.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    stack_name = var.stack_name
  }, var.additional_tags)
}