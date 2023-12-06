#
# Configuration
#
variable "name" {
  description = "Name of this queue instance"
  type        = string
  default     = "queue"
  nullable    = false
}

variable "environment" {
  description = "The environment this stack will be identified as (dev/staging/prod/etc)"
  type        = string
  default     = "production"
  nullable    = false
}

variable "tags" {
  description = "An optional map of tags to add to items created that support tagging"
  type        = map(string)
  default     = {}
}

variable "stack_name" {
  description = "The prefix for the stack to be created under"
  type        = string
  default     = "datable"
  nullable    = false
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

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = ""
}

variable "port" {
  description = "Port the service will expose"
  type        = number
  default     = 5432
}


#
# Tuning
#
variable "pg_version" {
  description = "Version of PostgreSQL to use"
  type        = string
  default     = "15.2"
}

variable "instance_class" {
  description = "Class of instance RDS will use"
  type        = string
  default     = "db.t3.micro"
}

variable "storage_type" {
  description = "Type of underlying storage to use"
  type        = string
  default     = "gp2"
}

variable "storage_allocation" {
  description = "Amount of storage space to allocate in GB"
  type        = number
  default     = 20
}



variable "vpc_id" {
  description = "VPC where timescale is running"
  type        = string
}

variable "namespace_id" {
  description = "The discovery namespace to use"
  type        = string
}

variable "subnet_group_name" {
  description = "Name of the subnet group, used to identify the VPC to create the RDS instance"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet IDs to place the database instances"
  type        = list(string)
  default     = []
}


#
# Locals
#
locals {
  major_version = element(regex("^([0-9]+)\\.?.*", var.pg_version), 0)

  db_name = var.db_name != "" ? var.db_name : "${var.stack_name}_${var.name}_${var.environment}"

  tags = merge(var.tags,
    {
      Service     = "${var.stack_name}-timescale"
      Environment = var.environment
    }
  )
}
