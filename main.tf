provider "aws" {
  region = "ap-south-1"
}

data "aws_nat_gateway" "nat" {
  id = "nat-0a34a8efd5e420945"
}

data "aws_vpc" "vpc" {
  id = "vpc-06b326e20d7db55f9"
}

data "aws_iam_role" "lambda" {
  name = "DevOps-Candidate-Lambda-Role"
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.87.0/24"
  availability_zone = "aps1-az1"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = data.aws_vpc.vpc.id

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
  memory_size      = 128
  timeout          = 30
  source_code_hash = filebase64sha256("lambda_function.zip")

  vpc_config {
    security_group_ids = [aws_security_group.lambda_sg.id]
    subnet_ids         = [aws_subnet.private.id]
  }
}
