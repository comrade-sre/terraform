output "kubeconfig" {
  value = module.eks.kubeconfig
}
output "instance_name" {
  value = module.ec2_proxy.instance_name
}

