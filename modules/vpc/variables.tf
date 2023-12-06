#
# Configuration
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

variable "tags" {
  description = "An optional map of tags to add to items created that support tagging"
  type        = map(string)
  default     = {}
}



#
# Networking
#
variable "cidr" {
  description = "IPv4 CIDR for VPC networking"
  type        = string
  default     = "192.168.0.0/16"
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for the VPC"
  type        = bool
  default     = false
}

#
# Locals
#
locals {
  azs = data.aws_availability_zones.available.names

  tags = merge(var.tags,
    {
      Environment = var.environment
    }
  )
}
