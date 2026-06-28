# chattingway-terraform

Terraform module to quickly spin up my chat bots.

To use this module, use the following as the source: `github.com/kn-lim/terraform-aws-chattingway`

Make sure to build the binaries, name it `bootstrap` and compress them into .zip files in order for Terraform to create the resources. This will need to be done only when first applying the module.

<!-- BEGIN_TF_DOCS -->
## Example

### dreamingway-bot

```hcl
terraform {
  required_version = ">= 1.10"
}

locals {
  name                       = "dreamingway-bot"
  account_id                 = ""
  debug                      = "false"
  discord_api_version        = "10"
  discord_bot_application_id = ""
  discord_bot_public_key     = ""
  discord_bot_token          = ""

  # These non-empty .zip files are needed only when creating resources.
  # Run the build commands and zip the binary files.
  # The .zip file an be deleted/moved afterwards.
  endpoint_filename = "/path/to/endpoint.zip"
  task_filename     = "/path/to/task.zip"
}

module "dreamingway-bot" {
  # https://github.com/kn-lim/chattingway-terraform
  source = "github.com/kn-lim/chattingway-terraform?ref=v1.2.1"

  # Required

  account_id        = local.account_id
  endpoint_filename = local.endpoint_filename
  task_filename     = local.task_filename
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
  # region            = "us-west-2"
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.52.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.endpoint](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.task](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.endpoint](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role) | resource |
| [aws_iam_role.task](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.invoke](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.manage_ec2](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_logs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_logs_task](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.endpoint](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/lambda_function) | resource |
| [aws_lambda_function.task](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/resources/lambda_permission) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.52.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS account ID | `string` | n/a | yes |
| <a name="input_ec2_instance_arns"></a> [ec2\_instance\_arns](#input\_ec2\_instance\_arns) | A list of EC2 instance ARNs to manage | `list(string)` | `[]` | no |
| <a name="input_endpoint_environment_variables"></a> [endpoint\_environment\_variables](#input\_endpoint\_environment\_variables) | A map of environment variables to apply to the Endpoint Lambda function | `map(string)` | n/a | yes |
| <a name="input_endpoint_filename"></a> [endpoint\_filename](#input\_endpoint\_filename) | The filename to upload to the Endpoint Lambda function | `string` | n/a | yes |
| <a name="input_endpoint_timeout"></a> [endpoint\_timeout](#input\_endpoint\_timeout) | The timeout for the Endpoint Lambda function | `number` | `3` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | The log format for the CloudWatch logs | `string` | `"JSON"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resources | `string` | `"chattingway"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain logs in CloudWatch | `number` | `3` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime for the Lambda functions | `string` | `"provided.al2023"` | no |
| <a name="input_task_environment_variables"></a> [task\_environment\_variables](#input\_task\_environment\_variables) | A map of environment variables to apply to the Task Lambda function | `map(string)` | n/a | yes |
| <a name="input_task_filename"></a> [task\_filename](#input\_task\_filename) | The filename to upload to the Task Lambda function | `string` | n/a | yes |
| <a name="input_task_timeout"></a> [task\_timeout](#input\_task\_timeout) | The timeout for the Task Lambda function | `number` | `300` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The endpoint for the API Gateway |
| <a name="output_endpoint_function_arn"></a> [endpoint\_function\_arn](#output\_endpoint\_function\_arn) | The ARN of the Endpoint Lambda function |
| <a name="output_task_function_arn"></a> [task\_function\_arn](#output\_task\_function\_arn) | The ARN of the Task Lambda function |
<!-- END_TF_DOCS -->
