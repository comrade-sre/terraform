provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
# Create a new AWS Instance
resource "aws_instance" "master" {
  ami           = "ami-040a1551f9c9d11ad"
  instance_type = "t2.micro"
}
