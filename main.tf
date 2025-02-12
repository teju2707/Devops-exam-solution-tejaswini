provider "aws" {
  region = "ap-south-1"
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.88.0/24"  # Change to a non-conflicting CIDR block
  availability_zone = "ap-south-1a"
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
