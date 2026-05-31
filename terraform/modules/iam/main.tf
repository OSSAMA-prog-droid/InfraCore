resource "aws_iam_role" "app_role" {
  name = "axiom-${var.environment}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# BUG IC-03: This policy grants Action = "*" on Resource = "*".
# Every EC2 instance running with this role can read, modify, or delete
# ANY resource in the AWS account — S3 buckets, RDS instances, IAM users,
# billing data, everything. A single compromised application container
# becomes a full account takeover.
#
# Fix: apply least-privilege. List only the specific actions the app needs,
# e.g. s3:GetObject on the assets bucket, secretsmanager:GetSecretValue on
# specific secrets, and nothing else.
resource "aws_iam_role_policy" "app_policy" {
  name = "axiom-${var.environment}-app-policy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "axiom-${var.environment}-app-profile"
  role = aws_iam_role.app_role.name
}
