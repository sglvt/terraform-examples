# EKS node group 1 variables

variable "eks_node_group_1_ebs_optimized" {
  type = string
  description = "The ebs_optimized attribute of the launch configuration"
}


variable "eks_node_group_1_instance_type" {
  type = string
  description = "The instance_type attribute of the launch configuration"
}

variable "eks_node_group_1_associate_public_ip_address" {
  type = string
  description = "The associate_public_ip_address attribute of the launch configuration"
}

variable "eks_node_group_1_key_name" {
  type = string
  description = "The key_name attribute of the launch configuration"
}

variable "eks_node_group_1_max_size" {
  type = string
  description = "EKS node group - on-demand - max size"
}

variable "eks_node_group_1_min_size" {
  type = string
  description = "EKS node group - on-demand - min size"
}

# Mixed Instances Policy

variable "eks_node_group_1_on_demand_base_capacity" {
  type = string
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
}

variable "eks_node_group_1_on_demand_percentage_above_base_capacity" {
  type = string
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
}

variable "eks_node_group_1_spot_allocation_strategy" {
  type = string
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
}

variable "eks_node_group_1_spot_instance_pools" {
  type = string
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
}

variable "eks_node_group_1_spot_max_price" {
  type = string
  description = "EC2 spot price"
}


variable "eks_node_group_1_pre_userdata" {
  type = string
  description = "User data before bootstrap.sh"
  default = ""
}

variable "eks_node_group_1_bootstrap_extra_args" {
  type = string
  description = "Extra arguments for bootstrap.sh"
  default = ""
}

variable "eks_node_group_1_kubelet_extra_args" {
  type = string
  description = "Arguments to be used for --kubelet-extra-args"
  default = ""
}

variable "eks_node_group_1_additional_userdata" {
  type = string
  description = "User data after bootstrap.sh"
  default = ""
}