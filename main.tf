provider "aws" {
  profile = "default"
  region  = var.region
  version = "~> 2.41"
}
provider "helm" {
  version = "~> 0.10"
}
provider "kubernetes" {
  version = "~> 1.10"
}
module "ec2_proxy" {
  source = "./modules/ec2_proxy/"

  ami        = var.ami
  type       = var.type
  subnet     = var.subnet
  sg_default = var.sg_default
  tag        = var.tag
  pub_ip     = var.pub_ip
  timeout    = var.timeout
  vol_size   = var.vol_size
  cidrs      = var.cidrs
  vpc_main   = var.vpc_main
  key_name   = var.key_name
  key        = var.key
}
module "eks" {
  source = "./modules/eks/"

  vpc_main  = var.vpc_main
  subnet    = var.subnet-eks
  subnet_2  = var.subnet
  workerKey = var.workerKey
}
module "workload" {
  source = "./modules/workload/"

  wp_pass = var.wp_pass
  wp_user = var.wp_user
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-for-comrade"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-for-comrade"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  backend "s3" {
    bucket = "terraform-state-for-comrade"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-locks-for-comrade"
    encrypt        = true
  }
}
