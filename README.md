# Generic Steps
Initialize and create resources
```
terraform init
terraform apply -var-file <var-file>
```

Destroy resources

```
terraform destroy -var-file <var-file>
```

# Examples
## AWS
### VPC

Path: `aws/vpc`

#### 1 public subnet

var-file: `values-1-az-public-only.tfvars`

A VPC with 1 public subnet and 1 private subnet.


#### 1 public subnet and 1 private subnet

var-file: `values-1-az-public-private.tfvars`

A VPC with 1 public subnet and 1 private subnet.

Traffic from the private subnets is routed through NAT gateways.

#### 3 public subnets and 3 private subnets

var-file: `values-3-az-public-private.tfvars`

A VPC with 3 public subnets and 3 private subnets.

Traffic from the private subnets is routed through NAT gateways.

