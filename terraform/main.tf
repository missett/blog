locals {
  region = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ryanmissett-terraform-backend"
    key    = "blog"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      managed-by = "ryanmissett-terraform"
    }
  }
}
