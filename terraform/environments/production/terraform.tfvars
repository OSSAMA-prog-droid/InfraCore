# BUG IC-06: AWS credentials and application secrets are hardcoded in this
# version-controlled file. Any developer with repo read access — or any attacker
# who compromises the repository — now has full AWS account access and can
# read, modify, or delete all production infrastructure and data.
#
# Fix: remove all credentials from tfvars. Use environment variables
# (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY) or an IAM instance role.
# Store secrets in AWS Secrets Manager or HashiCorp Vault.

aws_access_key = "AKIAIOSFODNN7EXAMPLE"
aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
db_username    = "axiom_admin"
db_password    = "Pr0duct10n#DB2024!"
region         = "us-east-1"
environment    = "production"
