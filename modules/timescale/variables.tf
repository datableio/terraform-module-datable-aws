#
# Configuration
#
variable "environment" {
  description = "The environment this stack will be identified as (dev/staging/prod/etc)"
  type        = string
  default     = "production"
  nullable    = false
}

variable "image" {
  description = "TimescaleDB container image to use"
  type        = string
  default     = "timescale/timescaledb:latest-pg15"
  nullable    = false
}

variable "stack_name" {
  description = "The prefix for the stack to be created under"
  type        = string
  default     = "datable"
  nullable    = false
}

variable "port" {
  description = "Port the service will expose"
  type        = number
  default     = 5432
}

variable "tags" {
  description = "An optional map of tags to add to items created that support tagging"
  type        = map(string)
  default     = {}
}

#
# Database
#
variable "username" {
  description = "Username used to connect to the timescale database"
  type        = string
  default     = "datable_user"
  nullable    = false
}

variable "password" {
  description = "Password used to connect to the timescale database"
  type        = string
  #sensitive   = true
  default  = "datable_password"
  nullable = false
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = ""
}

#
# Resources
#
variable "cpu" {
  description = "Amount of CPU to request per instance"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Amount of memory to request per instance"
  type        = number
  default     = 512
}


#
# AWS Specific
#
variable "ecs_cluster_arn" {
  description = "The ECS cluster to create the Timescale service"
  type        = string
}

variable "discovery_namespace_arn" {
  description = "The discovery namespace to use (ARN)"
  type        = string
}

variable "vpc_id" {
  description = "VPC where timescale is running"
  type        = string
}

variable "private_subnets" {
  description = "Subnet IDs to place the instances"
  type        = list(string)
  default     = []
}

variable "storage_subnets" {
  description = "Subnet IDs to place storage"
  type        = list(string)
  default     = []
}

#
# Locals
#
locals {
  name           = "timescaledb"
  container_name = "timescaledb"
  container_port = 5432

  db_name = var.db_name != "" ? var.db_name : "${var.stack_name}_${local.name}_${var.environment}"

  azs                = data.aws_availability_zones.available.names
  private_subnet_ids = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnets.vpc.ids
  storage_subnet_ids = length(var.storage_subnets) > 0 ? var.storage_subnets : data.aws_subnets.vpc.ids

  tags = merge(var.tags,
    {
      Service     = "${var.stack_name}-timescale"
      Environment = var.environment
    }
  )

  env_vars = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    },
    {
      name  = "TIMESCALEDB_TELEMETRY"
      value = "off"
    },
    {
      name  = "TS_TUNE_MAX_CONNS"
      value = "200"
    },
    {
      name  = "NO_TS_TUNE"
      value = "true"
    }
  ]
}
