resource "aws_vpc" "staging-vpc" {

  # cidr block of vpc
  cidr_block = "10.0.0.0/16"

  # tags to resources 
  tags = {
    Name = "staging-vpc"
  }

  # makes shared instances by default
  instance_tenancy = "default"

  # required by eks to enable and disable hostname support
  enable_dns_support   = true
  enable_dns_hostnames = true

  # auto assign ipv6 not reqiured
  assign_generated_ipv6_cidr_block = false
}

output "vpc_id" {
  value       = aws_vpc.staging-vpc.id
  description = "VPC_ID"

  sensitive = false # if true it will not shown by terraform
}