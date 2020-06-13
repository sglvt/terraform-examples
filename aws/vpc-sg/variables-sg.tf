variable "sg_demo_tcp_ingress" {
  type    = map(string)
  description = "Map between ports and CIDR blocks for custom TCP inbound rules"
}

variable "sg_demo_udp_ingress" {
  type    = map(string)
  description = "Map between ports and CIDR blocks for custom UDP inbound rules"
}

variable "sg_demo_any_ingress" {
  type    = list(string)
  description = "List of CIDR blocks for All Traffic inbound rules"
}


variable "sg_demo_tcp_egress" {
  type    = map(string)
  description = "Map between ports and CIDR blocks for custom TCP outbound rules"
}

variable "sg_demo_udp_egress" {
  type    = map(string)
  description = "Map between ports and CIDR blocks for custom UDP outbound rules"
}

variable "sg_demo_any_egress" {
  type    = list(string)
  description = "List of CIDR blocks for All Traffic outbound rules"
}