# tf-k8s-aws
This is a Terraform module to build a Kubernetes cluster in AWS.

Inspiration comes from:
* https://github.com/FutureSharks/tf-kops-cluster
* https://github.com/poseidon/typhoon
* https://github.com/poseidon/typhoon/pull/76

## Goals
* Fully leverage AWS-native capabilities when creating the resources. No SSH for provisioning.
* Allow placement within a predefined VPC.
* Enable AWS cloud provider features within Kubernetes itself
* Fully export useful resource IDs and names for later reference by other Terraform'd infrastructure

## Non-goals
* In-place upgrades
* Supporting every single permutation on the theme
* Supporting other public clouds (at this time)

## Features
* [2-4](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/self-hosted-kubernetes.md) self-hosted cluster via bootkube
* [terraform-render-bootkube](https://github.com/poseidon/terraform-render-bootkube) to render the initial bootkube assets
* AWS ELB for apiserver ingress
* Configurable security group rules for workers and masters so that these resources may be locked down
* User-provided VPC, user-defined AZs, user-defined subnets. Subnets are created 1-per-AZ within the specified VPC
* Custom tagging of resources in addition to those tags necessary for K8s to interface with AWS
* Container Linux AMIs
* Calico (preferred) or flannel CNI provider


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asg_tags | Tags to be added to ASG-defined resources | map | `<map>` | no |
| cluster_domain_suffix | Internal cluster DNS domain served by kube-dns | string | `cluster.local` | no |
| cluster_fqdn | FQDN for this cluster. Should be rooted under `route53_zone` | string | - | yes |
| cluster_name | Short name for this cluster. Should be unique across all clusters. | string | - | yes |
| config_s3_bucket | AWS S3 bucket to place bootkube rendered assets and ssl material for usage by the masters when bootstrapping | string | - | yes |
| config_s3_prefix | AWS S3 bucket key prefix, under which bootkube-assets.zip and various ssl files will be placed | string | `/` | no |
| master_type | EC2 instance type for master nodes | string | `t2.small` | no |
| network_mtu | CNI interface MTU. Use 8981 if you are using EC2 instances that support Jumbo frames. Only applicable with calico CNI provider | string | `1480` | no |
| network_provider | CNI provider: calico, flannel | string | `calico` | no |
| os_channel | Container Linux AMI channel (stable, beta, alpha) | string | `stable` | no |
| pod_cidr | Internal IPv4 CIDR for pods | string | `10.2.0.0/16` | no |
| route53_zone_id | Route53 zone id to place master and apiserver ELB resource records | string | - | yes |
| service_cidr | Internal IPv4 CIDR for services | string | `10.3.0.0/16` | no |
| tags | Tags to be added to terraform-defined resources | map | `<map>` | no |
| vpc_id | VPC id in which to place resources | string | - | yes |
| vpc_ig_id | VPC Internet Gateway | string | - | yes |
| vpc_subnet_cidrs | CIDRs of the subnets to create and launch EC2 instances in | string | - | yes |
| worker_asg_max | Worker node autoscaling group max size | string | `1` | no |
| worker_asg_min | Worker node autoscaling group min size | string | `1` | no |
| worker_type | EC2 instance type for worker nodes | string | `t2.small` | no |

