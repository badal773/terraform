resource "aws_subnet" "public-ap-south-1a" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name"                         = "public-ap-south-1a"
    "kubernets.io/role/elb"        = "1"
    "kubernets.io/cluster/staging" = "shared"
  }
}

resource "aws_subnet" "public-ap-south-1b" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name"                         = "public-ap-south-1b"
    "kubernets.io/role/elb"        = "1"
    "kubernets.io/cluster/staging" = "shared"
  }
}




resource "aws_subnet" "private-ap-south-1a" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.0.128.0/18"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    "Name"                           = "private-ap-south-1a"
    "kubernets.io/role/internal-elb" = "1"
    "kubernets.io/cluster/staging"   = "shared"
  }
}
resource "aws_subnet" "private-ap-south-1b" {

  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.0.192.0/18"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
  tags = {
    "Name"                           = "private-ap-south-1b"
    "kubernets.io/role/internal-elb" = "1"
    "kubernets.io/cluster/staging"   = "shared"
  }
}