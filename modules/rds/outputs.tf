output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the default database"
  value       = aws_db_instance.this.db_name
}

output "security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = aws_security_group.this.id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials"
  value       = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db.name
}