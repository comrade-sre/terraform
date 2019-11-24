variable "region" {
  default = "eu-central-1"
}
variable "ami" {}
variable "type" {}
variable "subnet" {}
variable "tag" {}
variable "pub_ip" {}
variable "timeout" {
	description = "timeout for starting and stoping instances"
 	type = "string"
}
variable "vol_size" {}
variable "cidrs" { type = list }
variable "sg_default" {}
variable "vpc_main" {}
variable "key_name" {
  	description = "ssh public key from my ec2 instances"
	type = "string"
}

