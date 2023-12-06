#
# Create a VPC for Datable to exist
#

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.stack_name}-vpc"
  cidr = var.cidr
  azs  = local.azs

  private_subnets     = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 8)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 12)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  # NAT config
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = !var.single_nat_gateway

  tags = local.tags
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.stack_name}.local"
  description = "Service discovery for ${var.stack_name}"
  vpc         = module.vpc.vpc_id
  tags        = local.tags
}

