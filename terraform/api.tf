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

resource "aws_apigatewayv2_api" "gateway" {
  name = "ryanmissett_blog_gateway"
  protocol_type = "HTTP"

  route_selection_expression = "$request.method $request.path"
  api_key_selection_expression = "$request.header.x-api-key"
  disable_execute_api_endpoint = false
}

resource "aws_apigatewayv2_stage" "gateway_default_stage" {
  api_id = aws_apigatewayv2_api.gateway.id
  name = "$default"
  auto_deploy = true
  
  route_settings {
    route_key = "$default"
    throttling_burst_limit = 1000
    throttling_rate_limit = 1000
  }
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = module.javascript_lambda["hello_world"].function.invoke_arn
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.gateway.id
  route_key = "ANY /"
  target = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
  authorization_type = "NONE"
}

