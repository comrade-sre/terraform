output "SG-id" {
  value = aws_security_group.eks-cluster.id
}
output "kubeconfig" {
  value = local.kubeconfig
}
