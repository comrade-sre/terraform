variable "region" {
  default = "eu-central-1"
}
variable "ami" {}
variable "type" {}
variable "subnet-start" {}
variable "tag" {}
variable "pub_ip" {}
variable "timeout" {}
variable "vol_size" {}
variable "cidrs" { type = list }
variable "sg_default" {}
variable "vpc-id" {}

