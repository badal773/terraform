resource "aws_iam_role" "nodegroup_role" {

  name               = "nodegroup_role"
  assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement":[
            {
                "Effect": "Allow",
                "Principal":{
                    "Service" : "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup_role.name
}


resource "aws_iam_role_policy_attachment" "node-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup_role.name

}
resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.nodegroup_role.name

}

resource "aws_iam_role_policy_attachment" "eks-service-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.nodegroup_role.name

}
resource "aws_eks_node_group" "nodegroup-1" {
  cluster_name    = aws_eks_cluster.stage-cluster.name
  node_group_name = "nodegroup-1"
  node_role_arn   = aws_iam_role.nodegroup_role.arn

  subnet_ids = [
    aws_subnet.private-ap-south-1a.id,
    aws_subnet.private-ap-south-1b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1

  }
  ami_type = "AL2_x86_64"

  capacity_type = "SPOT" #ON_DEMAND

  disk_size = 20

  # force version update if existing pod are unable to train due to pdb
  force_update_version = false

  instance_types = ["c6a.xlarge"]

  labels = {
    role = "nodegroup_role"
  }
  # nodegroup version
  version = 1.24


  depends_on = [
    aws_iam_role_policy_attachment.node-cni-policy,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.ecr_readonly_access_policy,
    aws_iam_role_policy_attachment.eks-cluster-policy,
    aws_iam_role_policy_attachment.eks-service-policy
  ]
}