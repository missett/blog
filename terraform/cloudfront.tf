locals {
  origin_id = "ryanmissett_blog_s3_bucket"
}

resource "aws_cloudfront_distribution" "ryanmissett_blog" {
  origin {
    domain_name = aws_s3_bucket.ryanmissett_blog_frontend.bucket_regional_domain_name
    origin_id = local.origin_id
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }

    default_ttl = 300
    min_ttl = 300
    max_ttl = 300
  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
