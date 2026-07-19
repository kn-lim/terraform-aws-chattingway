# terraform-aws-chattingway

![GitHub Workflow Status - Release](https://img.shields.io/github/actions/workflow/status/kn-lim/terraform-aws-chattingway/release.yaml)
![License](https://img.shields.io/github/license/kn-lim/chattingway)

Terraform module to quickly spin up my chat bots.

To use this module, use the following as the source: `github.com/kn-lim/terraform-aws-chattingway`

This module uses the community supported [terraform-aws-modules](https://github.com/terraform-aws-modules) to create all the AWS resources.

Make sure to build the binaries, name it `bootstrap` and compress them into separate `bootstrap.zip` files. Afterwards, upload the zip files into S3 in order for Terraform to create the resources. This will need to be done only when first applying the module.

<!-- BEGIN_TF_DOCS -->
## Example

### dreamingway-bot

```hcl
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
```

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.55.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_apigateway"></a> [apigateway](#module\_apigateway) | terraform-aws-modules/apigateway-v2/aws | 6.1.0 |
| <a name="module_endpoint"></a> [endpoint](#module\_endpoint) | terraform-aws-modules/lambda/aws | 8.8.0 |
| <a name="module_task"></a> [task](#module\_task) | terraform-aws-modules/lambda/aws | 8.8.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_lambda_permission.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.55.0/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ec2_instance_arns"></a> [ec2\_instance\_arns](#input\_ec2\_instance\_arns) | A list of EC2 instance ARNs to manage | `list(string)` | `[]` | no |
| <a name="input_endpoint_environment_variables"></a> [endpoint\_environment\_variables](#input\_endpoint\_environment\_variables) | A map of environment variables to apply to the Endpoint Lambda function | `map(string)` | n/a | yes |
| <a name="input_endpoint_s3_key"></a> [endpoint\_s3\_key](#input\_endpoint\_s3\_key) | S3 object key for the Endpoint Lambda deployment package | `string` | n/a | yes |
| <a name="input_endpoint_timeout"></a> [endpoint\_timeout](#input\_endpoint\_timeout) | The timeout for the Endpoint Lambda function | `number` | `3` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | The log format for the CloudWatch logs | `string` | `"JSON"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resources | `string` | `"chattingway"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain logs in CloudWatch | `number` | `3` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime for the Lambda functions | `string` | `"provided.al2023"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Name of the S3 bucket holding the Lambda deployment packages | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_task_environment_variables"></a> [task\_environment\_variables](#input\_task\_environment\_variables) | A map of environment variables to apply to the Task Lambda function | `map(string)` | n/a | yes |
| <a name="input_task_s3_key"></a> [task\_s3\_key](#input\_task\_s3\_key) | S3 object key for the Task Lambda deployment package | `string` | n/a | yes |
| <a name="input_task_timeout"></a> [task\_timeout](#input\_task\_timeout) | The timeout for the Task Lambda function | `number` | `300` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The endpoint for the API Gateway |
| <a name="output_endpoint_function_arn"></a> [endpoint\_function\_arn](#output\_endpoint\_function\_arn) | The ARN of the Endpoint Lambda function |
| <a name="output_task_function_arn"></a> [task\_function\_arn](#output\_task\_function\_arn) | The ARN of the Task Lambda function |
<!-- END_TF_DOCS -->
