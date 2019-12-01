output "SG-id" {
  value = aws_security_group.eks-cluster.id
}
output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

