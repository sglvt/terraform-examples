sg_demo_tcp_ingress = {
    "22" = "0.0.0.0/0",
    "80" = "10.0.0.0/24,10.1.0.0/24"
}

sg_demo_udp_ingress = {
    "53" = "10.0.0.0/24,10.1.0.0/24"
}

sg_demo_any_ingress = [
    "0.0.0.0/0"
]

sg_demo_tcp_egress = {
    "22" = "10.0.0.0/8"
}

sg_demo_udp_egress = {
    "53" = "10.0.0.0/8"
}

sg_demo_any_egress = [
    "0.0.0.0/0"
]