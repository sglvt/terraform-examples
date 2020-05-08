# Generic Steps
Initialize and create resources
```
terraform init
terraform apply -var-file values.tfvars
```

Destroy resources

```
terraform destroy -var-file values.tfvars
```

# Examples
## AWS
### vpc-3-az
A VPC with 3 public subnets, and 3 private subnets.
Traffic from the private subnets is routed through NAT gateways.

