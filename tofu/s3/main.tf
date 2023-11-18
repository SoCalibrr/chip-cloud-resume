resource "aws_s3_bucket" "cloud-resume-bucket" {
  bucket = "chip-cloud-resume"

  tags = {
    Name        = "chip-cloud-resume"
    Environment = "Development"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloud-resume-sse" {
  bucket = aws_s3_bucket.cloud-resume-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "cloud-resume-web-conf" {
  bucket = aws_s3_bucket.cloud-resume-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "cloud-resume-cors-conf" {
  bucket = aws_s3_bucket.cloud-resume-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "cloud-resume-bucket-public-access" {
  bucket = aws_s3_bucket.cloud-resume-bucket.id
}

resource "aws_s3_bucket_policy" "cloud-resume-public-read" {
  bucket = aws_s3_bucket.cloud-resume-bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "cloud-resume-public-read-policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.cloud-resume-bucket.arn}/*"
    ]
  }
}
