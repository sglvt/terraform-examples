# sg_a
variable "sg_a_ingress_from_self_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols from the same SG used for inbound rules"
  default = []
}

variable "sg_a_ingress_source_sg_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols, source SGs used for inbound rules"
  default = []
}

variable "sg_a_ingress_cidr_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols, CIDR (IPv4) blocks used for inbound rules"
  default = []
}

variable "sg_a_ingress_ipv6_cidr_list" {
  type    = list(string)
  description = "List of concatenated ports, protocols, CIDR (IPv6) blocks used for inbound rules"
  default = []
}

variable "sg_a_ingress_prefix_list_ids" {
  type    = list(string)
  description = "List of concatenated ports, protocols, prefix list ids used for inbound rules"
  default = []
}

variable "sg_a_egress_source_sg_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols, source sgs used for outbound rules"
  default = []
}

variable "sg_a_egress_cidr_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols, CIDR blocks used for outbound rules"
  default = [ 
    "0,0,-1,0.0.0.0/0,Allow any" 
  ]
}

variable "sg_a_egress_ipv6_cidr_list" {
  type    = list(string)
  description = "List of concatenated ports, protocols, CIDR (IPv6) blocks used for outbound rules"
  default = []
}

variable "sg_a_egress_prefix_list_ids" {
  type    = list(string)
  description = "List of concatenated ports, protocols, prefix list ids used for outbound rules"
  default = []
}

# sg_b
variable "sg_b_ingress_from_self_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols from the same SG used for inbound rules"
  default = []
}

variable "sg_b_ingress_cidr_list" {
  type    = list(string)
  description = "List of  concatenated ports, protocols, CIDR blocks used for inbound rules"
  default = []
}




