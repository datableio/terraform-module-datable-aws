#
# TimescaleDB instance
#
module "timescale" {
  source = "./modules/timescale"

  # General
  environment    = var.environment
  stack_name     = var.stack_name
  tags           = local.tags

  # Module specific
  image          = var.timescale_image

  # Networking
  private_subnets = module.vpc.private_subnets
  storage_subnets = module.vpc.intra_subnets

  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}

#
# Ingest Queue
#
module "queue" {
  source = "./modules/queue"

  # General
  name        = "queue"
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags

  # AWS info
  subnet_group_name = module.vpc.database_subnet_group_name
  subnet_ids        = module.vpc.database_subnets
  vpc_id            = module.vpc.vpc_id
  namespace_id      = module.vpc.discovery_namespace_id
}


#
# Rules Database
#
module "rulesdb" {
  source = "./modules/rulesdb"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags

  # AWS info
  subnet_group_name = module.vpc.database_subnet_group_name
  subnet_ids        = module.vpc.database_subnets
  vpc_id            = module.vpc.vpc_id
  namespace_id      = module.vpc.discovery_namespace_id
}

module "migrations" {
  source = "./modules/migrations"

  # General
  environment = var.environment
  stack_name  = var.stack_name
  tags        = local.tags
  image       = var.migrations_image

  # database info
  queue_config     = module.queue.connection_info
  rules_config     = module.rulesdb.connection_info
  timescale_config = module.timescale.connection_info


  # AWS info
  vpc_id                  = module.vpc.vpc_id
  ecs_cluster_arn         = module.ecs_cluster.cluster_arn
  discovery_namespace_arn = module.vpc.discovery_namespace_arn
}
