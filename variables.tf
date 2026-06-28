# Required

variable "endpoint_environment_variables" {
  description = "A map of environment variables to apply to the Endpoint Lambda function"
  type        = map(string)
  sensitive   = true
}

variable "endpoint_filename" {
  description = "The filename to upload to the Endpoint Lambda function"
  type        = string
}

variable "task_environment_variables" {
  description = "A map of environment variables to apply to the Task Lambda function"
  type        = map(string)
  sensitive   = true
}

variable "task_filename" {
  description = "The filename to upload to the Task Lambda function"
  type        = string
}

# Optional

variable "ec2_instance_arns" {
  description = "A list of EC2 instance ARNs to manage"
  type        = list(string)
  default     = []
}

variable "endpoint_timeout" {
  description = "The timeout for the Endpoint Lambda function"
  type        = number
  default     = 3
}

variable "log_format" {
  description = "The log format for the CloudWatch logs"
  type        = string
  default     = "JSON"
}

variable "name" {
  description = "The name of the resources"
  type        = string
  default     = "chattingway"
}

variable "retention_in_days" {
  description = "The number of days to retain logs in CloudWatch"
  type        = number
  default     = 3
}

variable "runtime" {
  description = "The runtime for the Lambda functions"
  type        = string
  default     = "provided.al2023"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "task_timeout" {
  description = "The timeout for the Task Lambda function"
  type        = number
  default     = 300
}
