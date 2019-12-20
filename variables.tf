variable "region" {
  default = "eu-central-1"
}
variable "ami" {}
variable "type" {}
variable "subnet" {}
variable "subnet-eks" {}
variable "tag" {}
variable "pub_ip" {}
variable "timeout" {
  description = "timeout for starting and stoping instances"
  type        = string
}
variable "vol_size" {}
variable "cidrs" { type = list }
variable "sg_default" {}
variable "vpc_main" {}
variable "key_name" {
  description = "ssh public key from my ec2 instances"
  type        = string
}

variable "cluster_name" {
  default = "eks-cluster"
  type    = string
}
variable "key" {}
variable "workerKey" {}
variable "dbuser" {}
variable "dbpass" {}
variable "wp_pass" {}
variable "wp_user" {}
