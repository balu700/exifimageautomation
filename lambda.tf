# Creating Lambda resource
resource "aws_lambda_function" "test_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_iam.arn
  handler          = "src/${var.handler_name}.lambda_handler"
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = "../src.zip"
  source_code_hash = filebase64sha256("../src.zip")
  environment {
    variables = {
      env            = var.environment
      SENDER_EMAIL   = var.sender_email
      RECEIVER_EMAIL = var.receiver_email
    }
  }
}

# Creating s3 resource for invoking to lambda function
resource "aws_s3_bucket" "bucket_a" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "bucket_b" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Environment = var.environment
  }
}


# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]

  }
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket_a.id}"
}
