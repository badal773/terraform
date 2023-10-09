resource "aws_nat_gateway" "nat-gtw" {

  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.public-ap-south-1a.id


  tags = {
    Name = "nat-gtw"
  }


}
