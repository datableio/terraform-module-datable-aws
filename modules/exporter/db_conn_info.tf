#
# Database connection variables / data / locals
#  Extracted here for reuse
#

variable "rules_config" {
  description = "Connection info used to access the rules database"
  type = object({
    host       = string
    port       = number
    user       = string
    database   = string
    secretFrom = string   # ARN to fetch the secret
  })
  default = {
    host       = "localhost"
    port       = 5432
    user       = "datable_user"
    secretFrom = ""
    database   = "datable_rules_production"
  }
}

variable "queue_config" {
  description = "Connection info used to access the ingest queue"
  type = object({
    host       = string
    port       = number
    user       = string
    database   = string
    secretFrom = string   # ARN to fetch the secret
  })
  default = {
    host       = "localhost"
    port       = 5432
    user       = "datable_user"
    secretFrom = ""
    database   = "datable_queue_production"
  }
}

variable "timescale_config" {
  description = "Connection info used to access the timescale database"
  type = object({
    host       = string
    port       = number
    user       = string
    password   = string
    database   = string
    secretFrom = string   # ARN to fetch the secret
  })
  default = {
    host       = "localhost"
    port       = 5432
    user       = "datable_user"
    password   = ""
    secretFrom = ""
    database   = "datable_timescale_production"
  }
}


# Queue
data "aws_secretsmanager_secret" "queue_secret" {
  arn = var.queue_config.secretFrom
}

data "aws_secretsmanager_secret_version" "queue_secret_current" {
  secret_id = data.aws_secretsmanager_secret.queue_secret.id
}

# Rules
data "aws_secretsmanager_secret" "rules_secret" {
  arn = var.rules_config.secretFrom
}

data "aws_secretsmanager_secret_version" "rules_secret_current" {
  secret_id = data.aws_secretsmanager_secret.rules_secret.id
}


locals {
  queue_data = jsondecode(data.aws_secretsmanager_secret_version.queue_secret_current.secret_string)
  rules_data = jsondecode(data.aws_secretsmanager_secret_version.rules_secret_current.secret_string)

  queue_password     = local.queue_data.password
  rules_password     = local.rules_data.password
  timescale_password = var.timescale_config.password


  db_env_vars = [
    {
      name  = "RULES_HOST"
      value = var.rules_config.host
    },
    {
      name  = "RULES_USERNAME"
      value = var.rules_config.user
    },
    {
      name  = "RULES_PASSWORD"
      value = local.rules_password
    },
    {
      name  = "RULES_NAME"
      value = var.rules_config.database
    },
    {
      name  = "QUEUE_HOST"
      value = var.queue_config.host
    },
    {
      name  = "QUEUE_USERNAME"
      value = var.queue_config.user
    },
    {
      name  = "QUEUE_PASSWORD"
      value = local.queue_password
    },
    {
      name  = "QUEUE_NAME"
      value = var.queue_config.database
    },
    {
      name  = "TIMESCALE_HOST"
      value = var.timescale_config.host
    },
    {
      name  = "TIMESCALE_USERNAME"
      value = var.timescale_config.user
    },
    {
      name  = "TIMESCALE_PASSWORD"
      value = local.timescale_password
    },
    {
      name  = "TIMESCALE_NAME"
      value = var.timescale_config.database
    }
  ]
}

