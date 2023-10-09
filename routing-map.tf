# create route table maping for public az to int-gtw public 

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-ap-south-1a.id
  route_table_id = aws_route_table.public-igw.id
}


resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-ap-south-1b.id
  route_table_id = aws_route_table.public-igw.id
}


# create route table maping for private az to nat-gtw public 


resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-ap-south-1a.id
  route_table_id = aws_route_table.private-nat.id
}


resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-ap-south-1b.id
  route_table_id = aws_route_table.private-nat.id
}

