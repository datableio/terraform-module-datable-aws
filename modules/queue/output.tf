output "connection_info" {
  description = "All the connection config info"
  value       = {
    host       = module.queue.db_instance_address
    port       = module.queue.db_instance_port
    user       = module.queue.db_instance_username
    database   = module.queue.db_instance_name
    secretFrom = module.queue.db_instance_master_user_secret_arn
  }
}
