## TL;DR
Setup the a test EKS cluster
```
git clone https://github.com/serbangilvitu/terraform-examples.git
cd terraform-examples/aws/eks-autoscaling
# Update aws_region and aws_profile in values-common.auto.tfvars
terraform init
terraform apply

export AWS_REGION=$(terraform output aws_region)
aws eks \
  --region ${AWS_REGION} \
  --profile $(terraform output aws_profile) \
  update-kubeconfig \
  --name $(terraform output eks_cluster_name)

export eks_node_group_1_role_arn="$(terraform output eks_node_group_1_role_arn)" && \
  curl -so - https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-07-23/aws-auth-cm.yaml \
  | sed -e 's/<ARN.*>/${eks_node_group_1_role_arn}/g' | envsubst \
  | tee | kubectl apply -f -
```
Deploy a cluster autoscaler using a Helm chart
```
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update
helm install cluster-autoscaler autoscaler/cluster-autoscaler-chart \
  --namespace kube-system \
  --version 1.0.4 \
  --set 'nameOverride'='cluster-autoscaler' \
  --set 'cloudProvider'='aws' \
  --set 'awsRegion'="${AWS_REGION}" \
  --set 'image.repository'='k8s.gcr.io/autoscaling/cluster-autoscaler' \
  --set 'image.tag'='v1.18.2' \
  --set 'autoDiscovery.clusterName'="$(terraform output eks_cluster_name)" \
  --set 'extraArgs.skip-nodes-with-system-pods'='false' \
  --set 'extraArgs.balance-similar-node-groups'='true' \
  --set 'extraArgs.expander'='least-waste' \
  --set 'extraArgs.skip-nodes-with-local-storage'='false'

kubectl -n kube-system \
  annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

Test autoscaling
* in one terminal
```
kubectl -n kube-system logs -f deployment/cluster-autoscaler
```
* in another terminal
```
kubectl -n default apply -f https://raw.githubusercontent.com/serbangilvitu/terraform-examples/master/aws/eks-autoscaling/yaml/scaling-test.yaml
watch -n 5 kubectl get nodes
```

To cleanup
```
terraform destroy
```

## A closer look

As mentioned earlier, the autoscaling group has [the tags expected by the cluster autoscaler](https://github.com/serbangilvitu/terraform-examples/blob/master/aws/eks-autoscaling/main.tf#L196) - here's an excerpt from the Terraform code.
```
    "k8s.io/cluster-autoscaler/${var.stack_name}-${var.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"
```

These tags could be overwritten by specifying the `autoDiscovery.tags`, however I'll go with the current convention `k8s.io/cluster-autoscaler/*`.

Let's continue with the values used by the autoscaler.

For some reason, in the [value file](https://github.com/kubernetes/autoscaler/blob/cluster-autoscaler-chart-1.0.4/charts/cluster-autoscaler-chart/values.yaml#L93) the default `cloudProvider` is `aws`, however it's best to specify it explicitly, so that you avoid surprises in future versions of the chart.

For the autodiscovery, I'm specifying the cluster name - in this case extracted from a terraform output.

In case of multiple autoscaling groups (this example only has 1) `least-waste` will expand the ASG that will waste the least amount of CPU/MEM resources.

I've also explicitly set `awsRegion` value, which defaults to [us-east-1](
https://github.com/kubernetes/autoscaler/blob/cluster-autoscaler-chart-1.0.4/charts/cluster-autoscaler-chart/values.yaml#L48) .

Additional options can be found in the [value file corresponding to the chart version](
https://github.com/kubernetes/autoscaler/blob/cluster-autoscaler-chart-1.0.4/charts/cluster-autoscaler-chart/values.yaml#L112), and some behavior is detailed in the [aws cloudprovider documentation](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md).

The complete list of arguments and their description is available in the [FAQ](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md).

The explanations for the ones I've explicitly specified:
* `skip-nodes-with-system-pods` - if true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods)
* `balance-similar-node-groups` - detect similar node groups and balance the number of nodes between them
* `expander` - if set to `least-waste`, when adding new nodes it selects the node group that will have the least idle CPU (if tied, unused memory) after scale-up
* `skip-nodes-with-local-storage` - if true cluster autoscaler will never delete nodes with pods with local storage, e.g. EmptyDir or HostPath

To check the chart's default extra arguments of the autoscaler:
```
helm show values autoscaler/cluster-autoscaler-chart \
  --version 1.0.4 \
  | grep 'extraArgs:' -A 20
```

To get a list of the user supplied values (which overwrite the defaults):
```
helm get values cluster-autoscaler
```