variable "cluster_name" {
  default = "eks-cluster"
  type    = string
}
variable "vpc_main" {}
variable "subnet" {}
variable "subnet_2" {}
locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-cluster.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.mentoring.endpoint}' --b64-cluster-ca '${aws_eks_cluster.mentoring.certificate_authority[0].data}' '${var.cluster_name}'
USERDATA

}

