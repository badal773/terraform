resource "aws_s3_bucket" "example" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "badal773"
    Environment = "Dev"
  }
}
provider "aws" {
  region     = "ap-south-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "AWS_SESSION_TOKEN" {}
