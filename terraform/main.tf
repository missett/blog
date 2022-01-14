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
  acl    = "private"
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

data "aws_iam_policy_document" "cloudfront_oai" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.ryanmissett_blog_frontend.arn}/*"]
    
    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.ryanmissett_blog.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_oai" {
  bucket = aws_s3_bucket.ryanmissett_blog_frontend.id
  policy = data.aws_iam_policy_document.cloudfront_oai.json
}
