output "instance_name" {
  value = aws_instance.master.public_dns
}
output "instance_addr" {
  value = aws_instance.master.public_ip
}
output "sg_proxy_id" {
  value = aws_security_group.sg_for_my_ec2.id
}
