resource "aws_internet_gateway" "staging-igw" {

  vpc_id = aws_vpc.staging-vpc.id

  tags = {
    Name = "staging-igw"
    devtron-cicd-component = "owned"
    devtron-email   = "devops@devtron.ai"

  }
}