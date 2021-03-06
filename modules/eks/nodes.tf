resource "aws_iam_role" "mentoring" {
  name = "eks-node-group-mentoring"

  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "mentoring-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.mentoring.name
}

resource "aws_iam_role_policy_attachment" "mentoring-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.mentoring.name
}

resource "aws_iam_role_policy_attachment" "mentoring-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.mentoring.name
}
resource "aws_security_group" "allow_ssh" {
  name = "ssh_to_workers"
  description = "security group for debugging nodes with ssh"
  vpc_id = var.vpc_main
  ingress {
    from_port = 0
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks       = ["109.252.110.0/24", "81.177.107.0/24"]
  }
}
resource "aws_eks_node_group" "mentoring" {
  cluster_name    = aws_eks_cluster.mentoring.name
  node_group_name = "mentoring"
  node_role_arn   = aws_iam_role.mentoring.arn
  subnet_ids      = ["${var.subnet}", "${var.subnet_2}"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  remote_access {
    ec2_ssh_key = var.workerKey
  }
  timeouts {
    create = "10m"
  }

  depends_on = [
    aws_iam_role_policy_attachment.mentoring-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.mentoring-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.mentoring-AmazonEC2ContainerRegistryReadOnly,
    aws_security_group.allow_ssh,
  ]
}

