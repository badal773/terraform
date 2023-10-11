module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  name            = "devtron-mng-ng"
  cluster_name    = aws_eks_cluster.stage-cluster.name
  cluster_version = "1.24"
  ami_type	=    "AL2_x86_64"

  subnet_ids = [aws_subnet.public-ap-south-1a.id]
  // Default is 20
  // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
  // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
  // use_custom_launch_template = false
  # disk_size = 50
  
  //  # Remote access cannot be specified with a launch template
  remote_access = {
      ec2_ssh_key               = "badal-test"
    }

  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types = ["t2.micro"]
  capacity_type  = "SPOT"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  tags = {
    devtron-cicd-component = "owned"
    devtron-email   = "devops@devtron.ai"
  }
}
