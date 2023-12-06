#
# Datable
#
variable "connect_key" {
  description = "Datable connection key"
  type        = string
}

variable "switchboard_url" {
  description = "Datable switchboard URL"
  type        = string
  default     = "wss://switchboard.datable.io"
}

#
# Configuration w/ defaults
#
variable "environment" {
  description = "The environment this stack will be identified as (dev/staging/prod/etc)"
  type        = string
  default     = "production"
}

variable "stack_name" {
  description = "The prefix for the stack to be created under"
  type        = string
  default     = "datable"
}

# VPC
variable "vpc_cidr" {
  description = "Network for VPC creation"
  type        = string
  default     = "192.168.0.0/16"
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for the VPC"
  type        = bool
  default     = false
}

variable "create_alb" {
  description = "Create an ALB for Edge ingest"
  type        = bool
  default     = true
}

variable "alb_security_groups" {
  description = "Security groups to apply to the ALB"
  type        = list(string)
  default     = []
}

variable "alb_security_group_cidr" {
  description = "Default security group CIDR. TESTING ONLY, supply your own security groups via alb_security_groups"
  type        = string
  default     = ""
}

#
# Image overrides
#
variable "edge_image" {
  description = "Edge container image to use"
  type        = string
  default     = "datableio/edge:latest"
}

variable "exporter_image" {
  description = "Exporter container image to use"
  type        = string
  default     = "datableio/exporter:latest"
}

variable "migrations_image" {
  description = "Migrations container image to use"
  type        = string
  default     = "datableio/migrations:latest"
}

variable "processor_image" {
  description = "Processor container image to use"
  type        = string
  default     = "datableio/processor:latest"
}

variable "query_image" {
  description = "Query container image to use"
  type        = string
  default     = "datableio/query:latest"
}

variable "ui_processor_image" {
  description = "UI Processor container image to use"
  type        = string
  default     = "datableio/ui_processor:latest"
}

variable "timescale_image" {
  description = "TimescaleDB container image to use"
  type        = string
  default     = "timescale/timescaledb:latest-pg15"
}


#
# Locals
#
locals {
  tags = {
    Environment = var.environment
    Project     = "datable"
  }
}
