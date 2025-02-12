provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "467.devops.candidate.exam"
    key    = "Tejaswini.Wakte" # Replace with your actual first and last name
    region = "ap-south-1"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Lambda SG"
  }
}

resource "aws_lambda_function" "invoke_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "InvokeLambda"
  role             = data.aws_iam_role.lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 30
  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      SUBNET_ID = aws_subnet.private.id
      NAME      = "Tejaswini LastName" # Replace with your actual name
      EMAIL     = "your.email@example.com" # Replace with your actual email address
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy]
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = data.aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
