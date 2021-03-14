terraform {
  backend "s3" {
    bucket  = "aws-s3-cicd-032021"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}