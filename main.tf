provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "467.devops.candidate.exam"
    key    = "<Your First Name>.<Your Last Name>"
    region = "ap-south-1"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "<VPC_ID>"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = "<VPC_ID>"

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
  role             = "<LAMBDA_ROLE_ARN>"
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
      NAME      = "<Your Full Name>"
      EMAIL     = "<Your Email Address>"
    }
  }
}
