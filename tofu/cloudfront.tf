resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name         = "chip-cloud-resume.s3-website-us-east-1.amazonaws.com"
    origin_id           = "chip-cloud-resume.s3-website-us-east-1.amazonaws.com"
    connection_attempts = 3
    connection_timeout  = 10

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = ["calvinwilson.app"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "chip-cloud-resume.s3-website-us-east-1.amazonaws.com"
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress         = true

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "development"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
    acm_certificate_arn            = aws_acm_certificate.cert.arn
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "calvinwilson.app"
  validation_method = "DNS"

  tags = {
    Environment = "development"
  }

  lifecycle {
    create_before_destroy = true
  }
}
