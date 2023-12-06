#
# Rule management backend items for Datable
#

module "rulesdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.1.1"

  identifier             = local.database_shortname
  engine                 = "postgres"
  family                 = "postgres${local.major_version}"
  major_engine_version   = local.major_version
  engine_version         = var.pg_version

  instance_class         = var.instance_class
  publicly_accessible    = false
  skip_final_snapshot    = true

  storage_type           = var.storage_type
  allocated_storage      = var.storage_allocation

  username               = var.username
  db_name                = local.db_name

  # This should of been created in the VPC already
  create_db_subnet_group = false
  db_subnet_group_name   = var.subnet_group_name
  subnet_ids             = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.vpc.ids

  vpc_security_group_ids = [module.security_group.security_group_id]

  tags = local.tags
}


#
# Service discovery config
#
resource "aws_service_discovery_service" "rulesdb" {
  name = local.database_shortname

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


#
# Allow access from within the VPC
#
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.database_shortname
  description = "Datable ${local.database_shortname} security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
    },
  ]

  tags = local.tags
}
