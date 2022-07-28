provider "aws" {
  region = "eu-west-1"
}

resource "aws_lambda_function" "MyLambdaFunction" {
  function_name = "${var.api_resource_name}-${var.env}-tf"

  filename = "${path.module}/lambda.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs12.x"

  role = "${aws_iam_role.FunctionExecutionRole.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "FunctionExecutionRole" {
  name = "${var.api_resource_name}-${var.env}-role-tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "APIInvokeLambdaPermission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.MyLambdaFunction.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_apigatewayv2_api.MyAPI.execution_arn}/*/*"
}

resource "aws_apigatewayv2_api" "MyAPI" {
  name        = "${var.api_resource_name}-${var.env}-tf"
  description = "Example HTTP API w Terraform"
  protocol_type = "HTTP"
  target = aws_lambda_function.MyLambdaFunction.arn
}

