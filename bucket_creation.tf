resource "aws_s3_bucket" "example" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "badal773"
    Environment = "Dev"
  }
}
provider "aws" {
  region     = "ap-south-1"
  access_key = $AWS_ACCESS_KEY_ID
  secret_key = $AWS_SECRET_ACCESS_KEY
  token = $AWS_SESSION_TOKEN

}
