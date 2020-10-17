variable "eks_cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "eks_version" {
  type = string
  description = "The version of the EKS cluster"
}

variable "eks_enabled_cluster_log_types" {
  type = list(string)
  description = "List of the desired control plane logging to enable"
}

variable "eks_endpoint_private_access" {
  type = string
  description = "Enable private API server endpoint"
}

variable "eks_endpoint_public_access" {
  type = string
  description = "Enable public API server endpoint"
}

variable "eks_public_access_cidrs" {
  type = list(string)
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled"
}