Result #1 HIGH IAM policy document uses sensitive action 'ec2:CreateNetworkInterface' on wildcarded resource '*'
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  policies.tf:37
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   71    data "aws_iam_policy_document" "combined" {
   72      source_policy_documents = [
   73        data.aws_iam_policy_document.ec2.json,
   74        data.aws_iam_policy_document.lambda.json,
   75        data.aws_iam_policy_document.logs.json
   76      ]
   77    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-iam-no-policy-wildcards
      Impact Overly permissive policies may grant access to sensitive resources
  Resolution Specify the exact permissions required, and to which resources they should apply instead of using wildcards.

  More Information
  - https://aquasecurity.github.io/tfsec/v1.26.0/checks/aws/iam/no-policy-wildcards/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #2 LOW Function does not have tracing enabled.
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  lambda.tf:44-65
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   44  ┌ resource "aws_lambda_function" "orca_eks_fetch" {
   45  │   filename         = "lambda_function_payload.zip"
   46  │   function_name    = "orca-k8s-collect-eks-private-cluster-yeeaosku"
   47  │   role             = aws_iam_role.orca_eks_fetch.arn
   48  │   handler          = "index.lambda_handler"
   49  │   timeout          = "900"
   50  │   source_code_hash = filebase64sha256("lambda_function_payload.zip")
   51  │
   52  └   runtime = "python3.8"
   ..
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.26.0/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
