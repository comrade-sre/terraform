output "kubeconfig" {
  value = module.eks.kubeconfig
}
output "instance_name" {
  value = module.ec2_proxy.instance_name
}

output "ssh" {
  value = module.code_commit.ssh
}
output "http" {
  value = module.code_commit.http
}
