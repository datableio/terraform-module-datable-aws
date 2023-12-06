#
# Services
#

module "processor" {
  source = "./modules/processor"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.processor_image

  # database info
  queue_config     = module.queue.connection_info
  rules_config     = module.rulesdb.connection_info
  timescale_config = module.timescale.connection_info

  # Networking
  private_subnets = module.vpc.private_subnets

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}

module "ui_processor" {
  source = "./modules/ui_processor"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.ui_processor_image

  # database info
  timescale_config = module.timescale.connection_info

  # Networking
  private_subnets = module.vpc.private_subnets

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}

module "exporter" {
  source = "./modules/exporter"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.exporter_image

  # database info
  queue_config     = module.queue.connection_info
  rules_config     = module.rulesdb.connection_info
  timescale_config = module.timescale.connection_info

  # Networking
  private_subnets = module.vpc.private_subnets

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}

module "query" {
  source = "./modules/query"

  # Datable config
  connect_key = var.connect_key
  switchboard_url = var.switchboard_url

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.query_image

  # database info
  queue_config     = module.queue.connection_info
  rules_config     = module.rulesdb.connection_info
  timescale_config = module.timescale.connection_info

  # Networking
  private_subnets = module.vpc.private_subnets

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}

module "edge" {
  source = "./modules/edge"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.edge_image

  # database info
  queue_config     = module.queue.connection_info
  rules_config     = module.rulesdb.connection_info
  timescale_config = module.timescale.connection_info

  # Networking
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  # ALB
  create_alb                = var.create_alb
  alb_security_groups       = var.alb_security_groups
  alb_security_group_cidr   = var.alb_security_group_cidr

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}
