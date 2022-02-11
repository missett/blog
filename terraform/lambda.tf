module "javascript-lambda" {
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
