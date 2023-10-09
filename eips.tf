resource "aws_eip" "nat-ip" {

  depends_on = [aws_internet_gateway.staging-igw]

}