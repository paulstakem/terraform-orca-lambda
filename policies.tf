data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    sid = "1"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "lambda:GetLayerVersion",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid = "3"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionEventInvokeConfig",
      "lambda:UpdateFunctionConfiguration"
    ]
    resources = ["arn:aws:lambda:*:111111111111:function:orca*"]
  }

  statement {
    sid = "4"
    actions = [
      "lambda:GetLayerVersion"
    ]
    resources = ["*"]
  }

  statement {
    sid = "3"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionEventInvokeConfig",
      "lambda:UpdateFunctionConfiguration"
    ]
    resources = ["arn:aws:lambda:*:111111111111:function:orca*"]
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.ec2.json,
    data.aws_iam_policy_document.lambda.json,
    data.aws_iam_policy_document.logs.json
  ]
}

data "aws_iam_policy_document" "vpce" {
  statement {
    sid = "5"
    actions = [
      "lambda:GetLayerVersion"
    ]
    resources = ["*"]
  }
}
