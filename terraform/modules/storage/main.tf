# BUG IC-05: acl = "public-read" makes ALL objects in this bucket readable
# by anyone on the internet without authentication. Event data, ML model
# artifacts, and customer-facing assets are all exposed.
# Additionally, versioning is not enabled — accidental overwrites or deletes
# of critical files (model weights, config snapshots) are unrecoverable.
#
# Fix: remove the acl attribute (default is private). Enable versioning.
# Use CloudFront with an OAC (Origin Access Control) to serve public assets.
resource "aws_s3_bucket" "assets" {
  bucket = "axiom-${var.environment}-assets"

  tags = {
    Name        = "axiom-${var.environment}-assets"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "assets" {
  bucket = aws_s3_bucket.assets.id
  acl    = "public-read"
}

resource "aws_s3_bucket" "ml_artifacts" {
  bucket = "axiom-${var.environment}-ml-artifacts"

  tags = {
    Name        = "axiom-${var.environment}-ml-artifacts"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "axiom-terraform-state"

  tags = {
    Name    = "axiom-terraform-state"
    Purpose = "terraform-state"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
