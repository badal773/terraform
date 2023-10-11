resource "aws_subnet" "public-ap-south-1a" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.0.0.0/16"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    "Name"                         = "public-ap-south-1a"
    "kubernets.io/role/nlb"        = "1"
    "kubernets.io/cluster/staging" = "owned"
    devtron-cicd-component = "owned"
    devtron-email   = "devops@devtron.ai"

  }
}
