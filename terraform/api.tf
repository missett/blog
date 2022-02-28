module "javascript_lambda" {
  for_each = {
    hello_world = {
      input_dir     = "hello-world"
      iam_role_name = "ryanmissett_blog_lambda_hello_world"
      function_name = "ryanmissett_blog_hello_world"
    }
    hello_again = {
      input_dir     = "hello-again"
      iam_role_name = "ryanmissett_blog_lambda_hello_world"
      function_name = "ryanmissett_blog_hello_again"
    }
  }

  source        = "../terraform-modules/javascript-lambda"
  input_dir     = "${path.module}/../lambda/${each.value.input_dir}/src"
  iam_role_name = each.value.iam_role_name
  function_name = each.value.function_name
}

resource "aws_api_gateway_rest_api" "ryanmissett_blog_api" {
  name = "ryanmissett_blog_api"
}

resource "aws_api_gateway_resource" "ryanmissett_blog_api" {
  path_part   = "hello_world"
  parent_id   = aws_api_gateway_rest_api.ryanmissett_blog_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.ryanmissett_blog_api.id
}

resource "aws_api_gateway_method" "ryanmissett_blog_api_get" {
  rest_api_id   = aws_api_gateway_rest_api.ryanmissett_blog_api.id
  resource_id   = aws_api_gateway_resource.ryanmissett_blog_api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_stage" "ryanmissett_blog_api_test" {
  deployment_id = aws_api_gateway_deployment.ryanmissett_blog_api_test.id
  rest_api_id   = aws_api_gateway_rest_api.ryanmissett_blog_api.id
  stage_name    = "test"
}

resource "aws_api_gateway_deployment" "ryanmissett_blog_api_test" {
  rest_api_id = aws_api_gateway_rest_api.ryanmissett_blog_api.id

  triggers = {
    #redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.ryanmissett_blog_api.id
  resource_id             = aws_api_gateway_resource.ryanmissett_blog_api.id
  http_method             = aws_api_gateway_method.ryanmissett_blog_api_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.javascript_lambda["hello_world"].function.invoke_arn
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.javascript_lambda["hello_world"].function.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:635451031443:${aws_api_gateway_rest_api.ryanmissett_blog_api.id}/*/${aws_api_gateway_method.ryanmissett_blog_api_get.http_method}${aws_api_gateway_resource.ryanmissett_blog_api.path}"
}
