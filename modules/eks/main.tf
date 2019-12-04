resource "aws_iam_role" "eks-cluster" {
  name               = "terraform-eks-cluster"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPlicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster.name
}


#SG for control plane
resource "aws_security_group" "eks-cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_main

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terrafrom"
  }
}
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["109.252.110.0/24"]
  description       = "Allow my workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

#Control plane init
resource "aws_eks_cluster" "mentoring" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-cluster.id}"]
    subnet_ids         = ["${var.subnet}", "${var.subnet_2}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPlicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy"
  ]
}


#SG for workers
resource "aws_security_group" "worker-node" {
  name = "terraform-eks-worker-node"
  description = "Security group for all nodes in the cluster"
  vpc_id = var.vpc_main
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "terraform-eks-worker-node"
    "kuberenetes.io/cluster/${var.cluster_name}" = "owned"
    
  }
}
resource "aws_security_group_rule" "worker-node-ingress-cluster" {
  description = "Allow worker kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.worker-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port = 65535
  type = "ingress"
 }
resource "aws_security_group_rule" "demo-node-ingress-self" {
  description = "Allow node to communicate to each other"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.worker-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  to_port = 65535
  type = "ingress"
}
resource "aws_security_group_rule" "demo-cluster-ingress" {
  description  = "Allow pods to communicate with the cluster API Server"
  from_port    = 443
  protocol = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  source_security_group_id = aws_security_group.worker-node.id
  to_port = 443
  type = "ingress"
}

data "aws_ami" "eks-worker" {
  filter {
    name = "name"
    values = ["awazon-eks-node${aws_eks_cluster.mentoring.version}-v*"]
  }
    most_recent = true
    owners      = ["602401143452"]
}
data "aws_region" "current" {
}

resource "aws_launch_configuration" "mentoring" {
  associate_public_ip_address = true
#  iam_instance_profile        = aws_iam_instance_profile.demo-node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks-mentoring"
  security_groups  = [aws_security_group.worker-node.id]
  user_data_base64 = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "mentoring" {
  desired_capacity = 2
  launch_configuration = aws_launch_configuration.mentoring.id
  max_size = 2
  min_size = 1
  name = "terraform-eks-mentoring"
  vpc_zone_identifier = ["${var.subnet}", "${var.subnet_2}"] 
  tag {
    key = "Mentoring"
    value = "true"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
}
