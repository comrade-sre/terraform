resource "aws_security_group" "sg_for_my_ec2" {
  name        = "proxy-sg"
  description = "SG for my proxy ec2"
  vpc_id      = var.vpc_main

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["109.252.110.0/24"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new AWS Instance
resource "aws_instance" "master" {
  ami                         = var.ami
  instance_type               = var.type
  key_name                    = var.key_name
  subnet_id                   = var.subnet
  associate_public_ip_address = var.pub_ip
  root_block_device {
    volume_size = var.vol_size
  }

  vpc_security_group_ids = ["${aws_security_group.sg_for_my_ec2.id}"]
  tags = {
    state = var.tag
  }
  volume_tags = {
    type = "default"
  }
  timeouts {
    create = var.timeout
    delete = var.timeout
  }
}
resource "aws_key_pair" "controller" {
  key_name   = "controller-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78vRhh1cW14xmaN6rqnkc9VEqMif5gO2wfvmz8srU94VcfnolOhSX/OGBASyOYni1yzik854XAbI8Svhyk4PNaxEKX8ICBDpAjQ1v05rHoHA8I32ahAY2cPVp4nZLmNGy6uO6ek0JDEyqOZVrSZa5wdZs34r9Qu/D5QoFa9utuqqeuM1J7l31WNWchBhxZGm/xG03TN2xcyVF9fU7BdMvqj/LyE7lwDKHZ1ll+yHyqLbY8Uhns4F04n2Iyjpzp2/fAM2FB/G4ypY+qT8Ozuu8G2fH3lwpU2yDCrc4WcVSNI/2ynpfYiAAKs6/+5AiAJLtK2E2YBcxwJU8YXOXw36V"
}

