terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



resource "aws_vpc" "staging-vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.common_tags

  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
}


resource "aws_subnet" "public-subnet-01" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = var.subnet_cidr_block_1
  availability_zone       = var.subnet_availability_zone1
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  tags                    = var.subnet_tags

  depends_on = [aws_vpc.staging-vpc]

}
resource "aws_subnet" "public-subnet-02" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = var.subnet_cidr_block_2
  availability_zone       = var.subnet_availability_zone2
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  tags                    = var.subnet_tags

  depends_on = [aws_vpc.staging-vpc]

}

resource "aws_internet_gateway" "staging-igw" {

  vpc_id = aws_vpc.staging-vpc.id

  tags = var.common_tags

  depends_on = [aws_vpc.staging-vpc]

}
# create route table for public 
resource "aws_route_table" "public-igw" {

  vpc_id = aws_vpc.staging-vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.staging-igw.id
  }
  tags       = var.common_tags
  depends_on = [aws_vpc.staging-vpc, aws_internet_gateway.staging-igw]

}

# create route table maping for public az to int-gtw public 

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public-igw.id

  depends_on = [aws_subnet.public-subnet-01, aws_route_table.public-igw]

}
resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-subnet-02.id
  route_table_id = aws_route_table.public-igw.id

  depends_on = [aws_subnet.public-subnet-02, aws_route_table.public-igw]


}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"


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
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  # master node /control plane version
  version = var.eks_version


  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

    subnet_ids = [aws_subnet.public-subnet-01.id, aws_subnet.public-subnet-02.id]
  }

  tags = var.common_tags

  depends_on = [aws_iam_role_policy_attachment.amazon_eks_cluster_policy]
}

resource "aws_launch_template" "stage-launch-template" {
  name_prefix = "custom-eks-node-group-"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.eks_node_group_disk_size
    }
  }

  network_interfaces {
    associate_public_ip_address = false
  }

  # Other configurations for the launch template
}

module "eks_managed_node_group" {
  source          = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  name            = var.eks_node_group_name
  cluster_name    = var.cluster_name
  cluster_version = var.eks_node_group_cluster_version
  ami_type        = var.eks_node_group_ami_type

  subnet_ids                 = [aws_subnet.public-subnet-01.id]
  use_custom_launch_template = true # Set this to true to use the default launch template
  launch_template_name       = aws_launch_template.stage-launch-template.name


  bootstrap_extra_args = "--kubelet-extra-args '--kube-reserved=cpu=200m,memory=200Mi,ephemeral-storage=1Gi' --kubelet-extra-args '--kube-reserved-cgroup=/kube-reserved' --kubelet-extra-args '--cpu-manager-policy=static' --kubelet-extra-args '--system-reserved=cpu=200m,memory=200Mi,ephemeral-storage=1Gi' --kubelet-extra-args '--eviction-hard=memory.available=200Mi,nodefs.available=10%' --kubelet-extra-args '--feature-gates=CPUManager=true,RotateKubeletServerCertificate=true'"



  min_size     = var.eks_node_group_min_size
  max_size     = var.eks_node_group_max_size
  desired_size = var.eks_node_group_desired_size

  instance_types = var.eks_node_group_instance_types
  capacity_type  = var.eks_node_group_capacity_type


  tags = var.common_tags


}


output "vpc_id" {
  value       = aws_vpc.staging-vpc.id
  description = "VPC_ID"
  sensitive   = false
}
output "cluster_name" {
  value       = aws_eks_cluster.eks-cluster.name
  description = "EKS Cluster Name"
}


