locals {
  origin_id = "ryanmissett_blog_s3_bucket"
}

resource "aws_cloudfront_origin_access_identity" "ryanmissett_blog" {
  
}

resource "aws_cloudfront_function" "ryanmissett_blog_index_redirect" {
  name = "ryanmissett-blog-index-redirect"
  runtime = "cloudfront-js-1.0"
  code = file("${path.module}/cloudfront-index-redirect.js")
}

resource "aws_cloudfront_distribution" "ryanmissett_blog" {
  origin {
    domain_name = aws_s3_bucket.ryanmissett_blog_frontend.bucket_regional_domain_name
    origin_id = local.origin_id
  
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.ryanmissett_blog.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"

  enabled = true

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

    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.ryanmissett_blog_index_redirect.arn
    }
  }

  custom_error_response {
    error_code = "404"
    response_code = "404"
    response_page_path = "/404.html"
  }

  custom_error_response {
    error_code = "403"
    response_code = "403"
    response_page_path = "/404.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
