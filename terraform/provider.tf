terraform {
  required_version = ">= 0.13.1"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}