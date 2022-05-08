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