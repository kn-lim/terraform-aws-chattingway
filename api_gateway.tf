module "apigateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "6.1.0"

  name          = "${var.name}-apigateway"
  description   = "API Gateway for ${var.name}"
  protocol_type = "HTTP"

  create_domain_name = false

  stage_access_log_settings = {
    log_group_retention_in_days = var.retention_in_days
  }

  routes = {
    "POST /" = {
      integration = {
        uri                    = module.endpoint.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
  }

  tags = var.tags
}
