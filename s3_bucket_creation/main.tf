variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "bucket-by-badal773" # optional default value 
}

variable "region_name" {
  description = "The region for the S3 bucket"
  type        = string
  default     = "us-west-2" # optional default value 
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name        #export TF_VAR_bucket_name="bucket-create-from-terrfrom-by-badal773"

  tags = {
    name        = "badal773"
    environment = "DevOps"
  }
}

provider "aws" {
  region = var.region_name    #export TF_VAR_region_name="ap-south-1"
}
