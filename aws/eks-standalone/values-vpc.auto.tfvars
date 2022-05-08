cidr_vpc = "10.0.0.0/16"
public_subnets = {
    "a" = "10.0.32.0/20"
    "b" = "10.0.96.0/20"
    "c" = "10.0.160.0/20"
}
private_subnets = {
}
create_nat_gateways = false
nat_gateway_az = []
nat_routes_for_private_subnets = []
igw_routes_for_public_subnets =  [ "0.0.0.0/0" ]
