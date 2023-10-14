aws_region = "ap-south-1"

vpc_cidr_block = "10.0.0.0/16"
common_tags = {
  Name                   = "staging-vpc"
  devtron-cicd-component = "owned"
  devtron-email          = "devops@devtron.ai"
}
instance_tenancy                 = "default"
enable_dns_support               = true
enable_dns_hostnames             = true
assign_generated_ipv6_cidr_block = false

subnet_cidr_block_1       = "10.0.0.0/19"
subnet_availability_zone1 = "ap-south-1a"
subnet_cidr_block_2       = "10.0.32.0/19"
subnet_availability_zone2 = "ap-south-1b"
subnet_tags = {
  "kubernets.io/role/nlb"        = "1"
  "kubernets.io/cluster/staging" = "owned"
  devtron-cicd-component         = "owned"
  devtron-email                  = "devops@devtron.ai"
}
subnet_map_public_ip_on_launch = true



cluster_name            = "staging-cluster"
eks_version             = "1.25"
endpoint_private_access = true
endpoint_public_access  = true
# subnet_ids              = [aws_subnet.public.id]



eks_node_group_name            = "stage-node"
eks_node_group_cluster_version = "1.25"
eks_node_group_ami_type        = "AL2_x86_64"
# eks_node_group_subnet_ids      = [aws_subnet.public.id]
eks_node_group_disk_size    = 30
eks_node_group_ec2_ssh_key  = "badal-test"
eks_node_group_min_size     = 1
eks_node_group_max_size     = 5
eks_node_group_desired_size = 3
# eks_node_group_instance_types = ["c6gn.xlarge", "c7g.xlarge", "r7gd.xlarge"]
eks_node_group_capacity_type  = "SPOT"
eks_node_group_instance_types = ["t2.micro"]