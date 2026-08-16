locals {
  ec2_policy_jsons = length(var.ec2_instance_arns) > 0 ? [jsonencode({
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
  })] : []

  counter_policy_jsons = var.enable_counter_table ? [jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:UpdateItem",
          "dynamodb:Query",
        ]
        Resource = [module.counter_table.dynamodb_table_arn]
      }
    ]
  })] : []

  task_policy_jsons = concat(local.ec2_policy_jsons, local.counter_policy_jsons)
}
