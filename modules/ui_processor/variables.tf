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
  description = "Container image to use"
  type        = string
  default     = "datableio/ui_processor:latest"
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
  default     = 3500
}

variable "monitor_port" {
  description = "Port used to fetch observability data from the container"
  type        = number
  default     = 9150
}

variable "tags" {
  description = "An optional map of tags to add to items created that support tagging"
  type        = map(string)
  default     = {}
}

#
# Resources
#
variable "max_instances" {
  description = "Limit the max number of auto-scaled instances"
  type        = number
  default     = 10
}

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

#
# Locals
#
locals {
  name           = "ui_processor"
  container_name = "ui_processor"
  container_port = 3500

  private_subnet_ids = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnets.vpc.ids

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
      name  = "NODE_ENV"
      value = var.environment
    },
    {
      name  = "PROM_PORT"
      value = var.monitor_port
    }
  ]
}
