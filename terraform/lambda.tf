data "archive_file" "ryanmissett_blog_hello_world" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/hello-world/src"
  output_path = "${path.module}/../lambda/hello-world/build.zip"
}

data "aws_iam_role" "ryanmissett_blog_lambda_hello_world" {
  name = "ryanmissett_blog_lambda_hello_world"
}

resource "aws_lambda_function" "ryanmissett_blog_hello_world" {
  depends_on       = [data.archive_file.ryanmissett_blog_hello_world]
  filename         = "${path.module}/../lambda/hello-world/build.zip"
  function_name    = "ryanmissett_blog_hello_world"
  role             = data.aws_iam_role.ryanmissett_blog_lambda_hello_world.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.ryanmissett_blog_hello_world.output_sha
  runtime          = "nodejs14.x"
}
