# Provider
output "aws_region" {
  value = var.aws_region
}

output "aws_profile" {
  value = var.aws_profile
}

# VPC
output "vpc_id" {
  value = module.vpc.id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "public_subnet_ids_by_az" {
  value = module.vpc.public_subnet_ids_by_az
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_subnet_ids_by_az" {
  value = module.vpc.private_subnet_ids_by_az
}

output "nat_gateway_public_eips" {
  value = module.vpc.nat_gateway_public_eips
}

# EKS - Control Plane
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_auth_base64" {
  value = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

# EKS - Node Group 1

output "eks_node_group_1_role_arn" {
  value = module.eks_node_group_1.role_arn
}