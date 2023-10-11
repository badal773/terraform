# create route table for public 
resource "aws_route_table" "public-igw" {

  vpc_id = aws_vpc.staging-vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.staging-igw.id
  }
  tags = {
    Name = "public"
    devtron-cicd-component = "owned"
    devtron-email   = "devops@devtron.ai"
  }
}

# create route table maping for public az to int-gtw public 

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-ap-south-1a.id
  route_table_id = aws_route_table.public-igw.id
}

