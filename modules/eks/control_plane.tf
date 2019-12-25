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
    Name = "terraform"
  }
}
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["109.252.110.0/24", "81.177.107.0/24"]
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
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPlicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy
  ]
}
#resource "null_resource" "generate_kubeconfig" {
#  depends_on = [aws_eks_cluster.mentoring]
#  provisioner "local-exec" {
#    command = "mkdir /root/.kube && echo $kubeconfig > /root/.kube/config"
#    environment = {
#      cluster_name = var.cluster_name
#      kubeconfig   = local.kubeconfig
#   }
# }
resource "null_resource" "generate_kubeconfig" {
  depends_on = [aws_eks_cluster.mentoring]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name $cluster_name"
    environment = {
      cluster_name = var.cluster_name
   }
 }
}

