resource "aws_api_gateway_rest_api" "example" {
  name = "visitors"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "/"
  lifecycle {
    ignore_changes = [ parent_id, path_part ]
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "dev"
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.api-resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Access-Control-Request-Headers" = false
    "method.request.header.Access-Control-Request-Methods" = false
  }
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.api-resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Access-Control-Request-Methods" = false
    "method.request.header.Access-Control-Request-Origin"  = false
  }
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.api-resource.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Access-Control-Request-Headers" = false
    "method.request.header.Access-Control-Request-Methods" = false
  }
}
