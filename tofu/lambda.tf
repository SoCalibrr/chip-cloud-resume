data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "cloud-resume-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/service-role/"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../src/backend/lambda/cloud-resume-update-count.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "lambda_function_payload.zip"
  function_name    = "cloud-resume-update-count"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.11"
}

resource "aws_cloudwatch_log_group" "cw-post-events" {
  name = "/aws/lambda/cloud-resume-update-count"

  tags = {
    Environment = "development"
  }
}

data "aws_iam_policy_document" "cw-execution-policy-0" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:us-east-1:488467487192:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:us-east-1:488467487192:log-group:/aws/lambda/cloud-resume-lambda:*"]
  }
}

resource "aws_iam_policy" "policy-0" {
  name        = "cw-execution-policy-0"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.cw-execution-policy-0.json
}

resource "aws_iam_role_policy_attachment" "test-attach-0" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy-0.arn
}

data "aws_iam_policy_document" "cw-execution-policy-1" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:us-east-1:488467487192:table/*"]
  }
}

resource "aws_iam_policy" "policy-1" {
  name        = "cw-execution-policy-1"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.cw-execution-policy-1.json
}

resource "aws_iam_role_policy_attachment" "test-attach-1" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy-1.arn
}


# tofu import aws_iam_role.iam_for_lambda cloud-resume-lambda-role
# tofu import aws_lambda_function.test_lambda cloud-resume-update-count
# tofu import aws_iam_policy.policy-0 cloud-resume-lambda-role:
# tofu import aws_iam_policy.policy-1 cloud-resume-lambda-role:
