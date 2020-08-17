eks_node_group_1_instance_type = "t3.medium"
eks_node_group_1_min_size = "1"
eks_node_group_1_max_size = "3"
eks_node_group_1_key_name = ""
eks_node_group_1_associate_public_ip_address = "true"
eks_node_group_1_ebs_optimized = "true"

## Mixed Instances Policy
eks_node_group_1_on_demand_base_capacity = "1"
eks_node_group_1_on_demand_percentage_above_base_capacity = "100"
eks_node_group_1_spot_allocation_strategy = "lowest-price"
eks_node_group_1_spot_instance_pools = "2"
eks_node_group_1_spot_max_price = "0.01"