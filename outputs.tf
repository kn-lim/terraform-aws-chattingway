output "api_endpoint" {
  description = "The endpoint for the API Gateway"
  value       = module.apigateway.api_endpoint
}

output "endpoint_function_arn" {
  description = "The ARN of the Endpoint Lambda function"
  value       = module.endpoint.lambda_function_arn
}

output "task_function_arn" {
  description = "The ARN of the Task Lambda function"
  value       = module.task.lambda_function_arn
}
