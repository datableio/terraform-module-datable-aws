# Create a VPC to contain Datable
module "vpc" {
  source = "./modules/vpc"

  cidr   = var.vpc_cidr

  # Not recommended for production
  single_nat_gateway = var.single_nat_gateway
}



#
# Define a cluster to run within
#
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.2.2"

  cluster_name = "${var.stack_name}-cluster"

  cloudwatch_log_group_retention_in_days = 7
  cluster_settings = { "name": "containerInsights", "value": "disabled" }

  default_capacity_provider_use_fargate = true

  tags = local.tags
}

