module "endpoint" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.8.0"

  function_name = "${var.name}-endpoint"
  handler       = "bootstrap"
  runtime       = var.runtime
  architectures = ["arm64"]
  timeout       = var.endpoint_timeout

  create_package          = false
  local_existing_package  = var.endpoint_filename
  ignore_source_code_hash = true

  environment_variables = var.endpoint_environment_variables

  cloudwatch_logs_retention_in_days = var.retention_in_days
  logging_log_format                = var.log_format

  attach_policy_json = true
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction"]
        Resource = [module.task.lambda_function_arn]
      }
    ]
  })

  tags = var.tags
}

module "task" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.8.0"

  function_name = "${var.name}-task"
  handler       = "bootstrap"
  runtime       = var.runtime
  architectures = ["arm64"]
  timeout       = var.task_timeout

  create_package          = false
  local_existing_package  = var.task_filename
  ignore_source_code_hash = true

  environment_variables = var.task_environment_variables

  cloudwatch_logs_retention_in_days = var.retention_in_days
  logging_log_format                = var.log_format

  attach_policy_json = length(var.ec2_instance_arns) > 0
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
        ]
        Resource = var.ec2_instance_arns
      }
    ]
  })

  tags = var.tags
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.endpoint.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apigateway.api_execution_arn}/*/*"
}
