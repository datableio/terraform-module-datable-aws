output "connection_info" {
  description = "All the connection config info"
  value       = {
    host       = module.rulesdb.db_instance_address
    port       = module.rulesdb.db_instance_port
    user       = module.rulesdb.db_instance_username
    database   = local.db_name
    secretFrom = module.rulesdb.db_instance_master_user_secret_arn
  }
}
