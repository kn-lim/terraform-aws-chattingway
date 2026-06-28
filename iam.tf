# Lambda

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "endpoint" {
  name               = "${var.name}-endpoint"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "task" {
  name               = "${var.name}-task"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "invoke" {
  name = "InvokeTaskLambdaFunction"
  role = aws_iam_role.endpoint.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          aws_lambda_function.task.arn
        ]
      },
    ],
  })
}

resource "aws_iam_role_policy" "manage_ec2" {
  count = length(var.ec2_instance_arns) == 0 ? 0 : 1

  name = "ManageEC2Instances"
  role = aws_iam_role.task.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
        ],
        Resource = var.ec2_instance_arns,
      },
    ],
  })
}

# CloudWatch

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.region}:${var.account_id}:log-group:/aws/lambda/${var.name}-*"]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name}-lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda function"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_endpoint" {
  role       = aws_iam_role.endpoint.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs_task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.this.arn
}
