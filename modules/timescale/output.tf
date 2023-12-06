output "connection_string" {
  description = "Database connection string"
  # container_name is used in the service_connect_configuration
  value       = "postgresql://${var.username}:${var.password}@${local.container_name}:${local.container_port}"
}

output "connection_info" {
  description = "All the connection config info"
  value       = {
    host       = local.container_name
    port       = var.port
    user       = var.username
    password   = var.password
    database   = local.db_name
    secretFrom = ""
  }
}

output "database_name" {
  description = "Final database name used by the instance"
  value       = local.db_name
}
