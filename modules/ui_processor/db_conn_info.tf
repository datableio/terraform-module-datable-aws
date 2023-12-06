#
# Database connection variables / data / locals
#  Extracted here for reuse
#

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

locals {
  timescale_password = var.timescale_config.password

  db_env_vars = [
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

