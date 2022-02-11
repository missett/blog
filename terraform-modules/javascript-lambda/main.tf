variable "input_dir" {
  type = string
}

variable "iam_role_name" {
  type = string
}

variable "function_name" {
  type = string
}

locals {
  output_path = "${dirname(var.input_dir)}/build.zip"
  nvm_file_contents = file("${dirname(var.input_dir)}/.nvmrc")
  node_major_version = split(".", trimprefix(local.nvm_file_contents, "v"))[0]
}

data "archive_file" "archive" {
  type        = "zip"
  source_dir  = var.input_dir
  output_path = local.output_path
}

data "aws_iam_role" "execution_role" {
  name = var.iam_role_name
}

resource "aws_lambda_function" "function" {
  depends_on       = [data.archive_file.archive]
  filename         = local.output_path
  function_name    = var.function_name
  role             = data.aws_iam_role.execution_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.archive.output_sha
  runtime          = "nodejs${local.node_major_version}.x"
}
