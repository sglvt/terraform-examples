aws_profile = "example"
aws_region = "eu-west-1"
stack_name = "demo"
additional_tags = {
    purpose = "something"
}
cidr_vpc = "10.0.0.0/16"
public_subnets = {
    "a" = "10.0.32.0/20"
}
private_subnets = {
}
create_nat_gateways = true
nat_gateway_az = []
nat_routes_for_private_subnets = [ "0.0.0.0/0" ]
igw_routes_for_public_subnets =  [ "0.0.0.0/0" ]