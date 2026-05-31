output "db_endpoint" {
  value     = aws_db_instance.primary.endpoint
  sensitive = true
}

output "db_name" {
  value = aws_db_instance.primary.db_name
}
