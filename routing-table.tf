# create route table for public 
resource "aws_route_table" "public-igw" {

  vpc_id = aws_vpc.staging-vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.staging-igw.id
  }
  tags = {
    Name = "public"
  }
}


# create route table for private 
resource "aws_route_table" "private-nat" {

  vpc_id = aws_vpc.staging-vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_nat_gateway.nat-gtw.id
  }

  tags = {
    Name = "priavte"
  }

}