# Configure the AWS Provider
provider "aws" {
  region     = "ap-south-1"
  # access_key = "AKIAQIEAVLIXE4LUNZOU"
  # secret_key = "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"

}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57.0"
    }
  }
}
