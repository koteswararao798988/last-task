terraform {
  required_version = ">= 0.13"
}
provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}
terraform {
  required_providers {
    remote = {
      source = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}
