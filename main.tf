/** 
* # tf-k8s-aws
* This is a Terraform module to build a Kubernetes cluster in AWS.
*
* Inspiration comes from:
* * https://github.com/FutureSharks/tf-kops-cluster
* * https://github.com/poseidon/typhoon
* * https://github.com/poseidon/typhoon/pull/76
*
* ## Goals
* * Fully leverage AWS-native capabilities when creating the resources. No SSH for provisioning.
* * Allow placement within a predefined VPC.
* * Enable AWS cloud provider features within Kubernetes itself
* * Fully export useful resource IDs and names for later reference by other Terraform'd infrastructure
*
* ## Non-goals
* * In-place upgrades
* * Supporting every single permutation on the theme
* * Supporting other public clouds (at this time)
*
* ## Features
* * [2-4](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/self-hosted-kubernetes.md) self-hosted cluster via bootkube
* * [terraform-render-bootkube](https://github.com/poseidon/terraform-render-bootkube) to render the initial bootkube assets
* * AWS ELB for apiserver ingress
* * Configurable security group rules for workers and masters so that these resources may be locked down
* * User-provided VPC, user-defined AZs, user-defined subnets. Subnets are created 1-per-AZ within the specified VPC
* * Custom tagging of resources in addition to those tags necessary for K8s to interface with AWS
* * Container Linux AMIs
* * Calico (preferred) or flannel CNI provider
*/

data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-${var.os_channel}-*"]
  }
}
