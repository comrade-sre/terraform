provider "aws" {
  profile = "default"
  region  = var.region
}
module "ec2_proxy" {
  source = "./modules/ec2_proxy/"

  ami        = "ami-040a1551f9c9d11ad"
  type       = "t2.micro"
  subnet     = "subnet-a82284c2"
  sg_default = "sg-1e48517c"
  tag        = "test"
  pub_ip     = "true"
  timeout    = "2m"
  vol_size   = "15"
  cidrs      = ["172.31.32.0/20", "172.31.0.0/20", "172.31.16.0/20"]
  vpc_main   = "vpc-5922dc33"
  key_name   = "controller-key"
}
module "eks" {
  source = "./modules/eks/"

  vpc_main = "vpc-5922dc33"
  subnet   = "subnet-50100c2d"
}

