provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "admin_user" {
  name = "AdminUser"
}

resource "aws_iam_user_policy_attachment" "admin_attach" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_account_password_policy" "strict_password_policy" {
  minimum_password_length        = 14
  require_symbols                = true
  require_numbers                = true
  require_uppercase_characters  = true
  require_lowercase_characters  = true
  allow_users_to_change_password = true
  max_password_age              = 90
  password_reuse_prevention     = 5
}
resource "aws_guardduty_detector" "main" {
  enable = true
}

resource "aws_kms_key" "ebs_key" {
  description             = "KMS key for EBS encryption"
  enable_key_rotation     = true
}

resource "aws_s3_bucket_public_access_block" "secure_bucket_block" {
  bucket = "my-secure-bucket"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = "my-secure-bucket"

  versioning_configuration {
    status = "Enabled"
  }
}