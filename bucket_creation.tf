resource "aws_s3_bucket" "example" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "badal773"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket" "example" {
  bucket = "bucket-create-from-tofu-controller-02"

  tags = {
    Name        = "badal773"
    Environment = "Dev"
  }
}

provider "aws" {
  region     = "ap-south-1"
}

