resource "aws_iam_role" "eks_cluster" {

  name = "eks_cluster"


  assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement":[
            {
                "Effect": "Allow",
                "Principal":{
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "stage-cluster" {
  name = "stage-cluster"

  role_arn = aws_iam_role.eks_cluster.arn

  # master node /control plane version
  version = "1.24"

  vpc_config {
    # either eks private api-server is enabled
    endpoint_private_access = false
    # public api-server is enabled
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.public-ap-south-1a.id,
      aws_subnet.public-ap-south-1b.id,
      aws_subnet.private-ap-south-1a.id,
      aws_subnet.private-ap-south-1b.id
    ]
  }



  depends_on = [aws_iam_role_policy_attachment.amazon_eks_cluster_policy]
}