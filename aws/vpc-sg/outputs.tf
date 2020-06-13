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

output "sg_demo" {
  value = module.sg_demo.id
}