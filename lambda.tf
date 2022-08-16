locals {
  name = "orca-eks-fetch"
}

resource "aws_iam_role" "orca_eks_fetch" {
  name               = var.function_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags = {
    "Orca" = "True"
  }
}

resource "aws_iam_role_policy" "orca_eks_fetch_policy" {
  name   = "OrcaLambdaPolicy"
  role   = aws_iam_role.orca_eks_fetch.id
  policy = data.aws_iam_policy_document.combined.json
}

###############################################################################

resource "aws_vpc_endpoint" "orca_eks_fetch" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.eu-west-2.lambda"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.subnet_ids
}

resource "aws_vpc_endpoint_policy" "orca_eks_fetch" {
  vpc_endpoint_id = aws_vpc_endpoint.orca_eks_fetch.id
  policy          = data.aws_iam_policy_document.vpce.json
}

###############################################################################

resource "aws_lambda_permission" "orca_eks_fetch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.orca_eks_fetch
  principal     = var.orca_role
  statement_id  = "orca-lambdaeks-private-cluster-yeeaosku-OrcaInvokePermission-1YD7J747F605"
}

resource "aws_lambda_function" "orca_eks_fetch" {
  filename         = "lambda_function_payload.zip"
  function_name    = "orca-k8s-collect-eks-private-cluster-yeeaosku"
  role             = aws_iam_role.orca_eks_fetch.arn
  handler          = "index.lambda_handler"
  timeout          = "900"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.8"

  layers = ["arn:aws:lambda:eu-west-2:976280145156:layer:kubernator:1"]

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  tags = {
    "Orca"             = "True"
    "TargetK8sCluster" = "eks-private-cluster"
  }
}
