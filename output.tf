output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.rds.username
}

output "rds_password" {
  description = "RDS instance root password"
  value       = aws_db_instance.rds.password
  sensitive = true
}

