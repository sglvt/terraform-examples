## AWS EKS - Setup with autoscaling
See AUTOSCALING.md - it focuses more on the Cluster Autoscaler setup, and starts from scratch ( includes details for creating the cluster).
Blog post: https://sgilvitu.io/posts/2020/10/eks-autoscaling/

## AWS EKS - Setup without autoscaling
Blog post: https://sgilvitu.io/posts/2020/08/minimal-eks-setup/

### Checkout

```
git clone https://github.com/serbangilvitu/terraform-examples.git
cd terraform-examples/aws/eks
```

### Customize AWS profile and region
The minimum customization that is required is to update the `aws_profile` and `aws_region` values in the values-common.auto.tfvars file.

### Apply changes
```
terraform init && terraform apply
```

The plan is presented, type `yes` if you agree with the resources being created.

### Update .kube/config
Update the ~/.kube/config file with the following command (replacing the placeholders)

```
aws eks --region <aws_region> update-kubeconfig --name <stack_name>-<aws_region> --profile <aws_profile>
```

With the default values, the command would be:

```
aws eks --region eu-west-1 update-kubeconfig --name demo-c1 --profile example
```

### aws-auth-cm

The following command will create the [aws-auth-cm](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) config map

```
export eks_node_group_1_role_arn="$(terraform output eks_node_group_1_role_arn)" && \
curl -so - https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-07-23/aws-auth-cm.yaml \
| sed -e 's/<ARN.*>/${eks_node_group_1_role_arn}/g' | envsubst \
| tee | kubectl apply -f -
```

### Watch nodes

After a short interval, the node should become ready
```
kubectl get nodes -w
```

