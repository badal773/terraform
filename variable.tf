variable "aws_region" {
  description = "The AWS region for the resources"
  type        = string
  default     = ""
}

variable "instance_tenancy" {
  description = "Tenancy setting for the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Assign generated IPv6 CIDR block"
  type        = bool
  default     = false
}
variable "common_tags" {
  description = "Common tags for AWS resources"
  type        = map(string)
  default = {
    Name                   = "staging-vpc"
    devtron-cicd-component = "owned"
    devtron-email          = "devops@devtron.ai"
  }
}

variable "subnet_tags" {
  description = "Tags for subnets"
  type        = map(string)
  default = {
    "kubernets.io/role/nlb"        = "1"
    "kubernets.io/cluster/staging" = "owned"
    devtron-cicd-component         = "owned"
    devtron-email                  = "devops@devtron.ai"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block_1" {
  description = "CIDR block of the subnet"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidr_block_2" {
  description = "CIDR block of the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_availability_zone1" {
  description = "Availability zone of the subnet"
  type        = string
  default     = "us-east-2"
}

variable "subnet_availability_zone2" {
  description = "Availability zone of the subnet"
  type        = string
  default     = "us-east-2"
}

variable "subnet_map_public_ip_on_launch" {
  description = "Whether to map public IP on launch for the subnet"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "test-cluster"
}

variable "eks_version" {
  description = "The version of the EKS cluster."
  type        = string
  default     = "1.26"

}

variable "endpoint_private_access" {
  description = "Enable or disable private API server access."
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable or disable public API server access."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
  default     = []
}

variable "eks_node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "devtron-mng-ng"
}

variable "eks_node_group_cluster_version" {
  description = "Cluster version for the EKS managed node group"
  type        = string
  default     = "1.24"
}

variable "eks_node_group_ami_type" {
  description = "AMI type for the EKS managed node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "eks_node_group_subnet_ids" {
  description = "Subnet IDs for the EKS managed node group"
  type        = list(string)
  default     = []
}

variable "eks_node_group_disk_size" {
  description = "Disk size for the EKS managed node group"
  type        = number
  default     = 30
}

variable "eks_node_group_ec2_ssh_key" {
  description = "SSH key for the EKS managed node group"
  type        = string
  default     = "badal-test"
}

variable "eks_node_group_min_size" {
  description = "Minimum size for the EKS managed node group"
  type        = number
  default     = 1
}

variable "eks_node_group_max_size" {
  description = "Maximum size for the EKS managed node group"
  type        = number
  default     = 2
}

variable "eks_node_group_desired_size" {
  description = "Desired size for the EKS managed node group"
  type        = number
  default     = 1
}

variable "eks_node_group_instance_types" {
  description = "Instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "eks_node_group_capacity_type" {
  description = "Capacity type for the EKS managed node group"
  type        = string
  default     = "SPOT"
}
