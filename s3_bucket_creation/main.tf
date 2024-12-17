variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "bucket-by-badal773" # optional default value 
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name        #export TF_VAR_bucket_name="bucket-create-from-terrfrom-by-badal773"

  tags = {
    name        = "badal773"
    environment = "DevOps"
  }
}

provider "aws" {
  region = "ap-south-1"
}
