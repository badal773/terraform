resource "aws_s3_bucket" "bucket-create-from-tofu-controller" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "badal773"
    Environment = "Dev"
  }
}

provider "aws" {
  region     = "ap-south-1"
}