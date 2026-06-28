terraform {
  required_version = ">= 1.15"
}

locals {
  name                       = "dreamingway-bot"
  admin_role_users           = ""
  debug                      = "false"
  discord_api_version        = "10"
  discord_bot_application_id = ""
  discord_bot_public_key     = ""
  discord_bot_token          = ""

  # The deployment packages must already exist in S3 at these keys before
  # applying. Build the binaries, zip them, and upload to the bucket (e.g. via
  # CI). Lambda code is managed out-of-band, so source code hash changes are
  # ignored by the module.
  s3_bucket       = "my-s3-bucket"
  endpoint_s3_key = "path/to/endpoint/bootstrap.zip"
  task_s3_key     = "path/to/task/bootstrap.zip"
}

module "dreamingway-bot" {
  # https://github.com/kn-lim/terraform-aws-chattingway
  source = "github.com/kn-lim/terraform-aws-chattingway?ref=v2.0.0"

  # Required

  s3_bucket       = local.s3_bucket
  endpoint_s3_key = local.endpoint_s3_key
  task_s3_key     = local.task_s3_key
  endpoint_environment_variables = {
    ADMIN_ROLE_USERS           = local.admin_role_users
    DEBUG                      = local.debug
    DISCORD_BOT_APPLICATION_ID = local.discord_bot_application_id
    DISCORD_BOT_PUBLIC_KEY     = local.discord_bot_public_key
    DISCORD_BOT_TOKEN          = local.discord_bot_token
    TASK_FUNCTION_NAME         = "${local.name}-task"
  }
  task_environment_variables = {
    DEBUG               = local.debug
    DISCORD_API_VERSION = local.discord_api_version
    DISCORD_BOT_TOKEN   = local.discord_bot_token
  }

  # Optional

  # name              = local.name
  # log_format        = "JSON"
  # retention_in_days = 3
  # runtime           = "provided.al2023"
  # endpoint_timeout  = 3
  # task_timeout      = 300
  # ec2_instance_arns = []
  # tags = {
  #   App = local.name
  # }
}

output "api_endpoint" {
  description = "The endpoint for the API Gateway"
  value       = module.dreamingway-bot.api_endpoint
}
