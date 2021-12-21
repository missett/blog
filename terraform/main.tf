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

locals {
  content_types = jsondecode(file("${path.module}/content-type-map.json"))
}

resource "aws_s3_bucket" "ryanmissett_blog_frontend" {
  bucket = "ryanmissett-blog-frontend"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_object" "ryanmissett_blog_frontend" {
  for_each     = fileset("${path.module}/../static/src/public", "**")
  bucket       = aws_s3_bucket.ryanmissett_blog_frontend.id
  key          = each.value
  source       = "${path.module}/../static/src/public/${each.value}"
  acl          = "public-read"
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5("${path.module}/../static/src/public/${each.value}")
}

