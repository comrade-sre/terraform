provider "aws" {
  profile = "default"
  region  = var.region
}
# Create a new AWS Instance
resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.type
  key_name      = "controller-key"
  subnet_id     = var.subnet
  tags = {
    state = var.tag
  }
}
resource "aws_key_pair" "controller" {
  key_name   = "controller-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78vRhh1cW14xmaN6rqnkc9VEqMif5gO2wfvmz8srU94VcfnolOhSX/OGBASyOYni1yzik854XAbI8Svhyk4PNaxEKX8ICBDpAjQ1v05rHoHA8I32ahAY2cPVp4nZLmNGy6uO6ek0JDEyqOZVrSZa5wdZs34r9Qu/D5QoFa9utuqqeuM1J7l31WNWchBhxZGm/xG03TN2xcyVF9fU7BdMvqj/LyE7lwDKHZ1ll+yHyqLbY8Uhns4F04n2Iyjpzp2/fAM2FB/G4ypY+qT8Ozuu8G2fH3lwpU2yDCrc4WcVSNI/2ynpfYiAAKs6/+5AiAJLtK2E2YBcxwJU8YXOXw36V"
}
variable "region" {
  default = "eu-central-1"
}
variable "ami" {}
variable "type" {}
variable "subnet" {}
variable "tag" {}
