terraform {
  required_version = ">= 0.13"
}
provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAVSK5TXBYEZ5VUHHG"
  secret_key = "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"
}
terraform {
  required_providers {
    remote = {
      source = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}
