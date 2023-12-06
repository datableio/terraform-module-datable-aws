#
# Create Query instances on ECS
#

#
# Service
#
module "query_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.2.2"

  name        = local.name
  family      = local.name
  cluster_arn = var.ecs_cluster_arn

  desired_count   = 1
  launch_type     = "FARGATE"

  cpu    = var.cpu
  memory = var.memory

  # Private as this is an internal service
  subnet_ids = local.private_subnet_ids

  autoscaling_min_capacity = 1
  autoscaling_max_capacity = var.max_instances

  container_definitions = {
    (local.container_name) = {
      cpu       = var.cpu
      memory    = var.memory
      essential = true

      image = var.image
      readonly_root_filesystem = false

      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        },
        {
          name          = "monitoring"
          containerPort = var.monitor_port
          protocol      = "tcp"
        },
      ]

      environment = concat(local.env_vars, local.db_env_vars)
    }
  }

  service_connect_configuration = {
    namespace = var.discovery_namespace_arn
    service = {
      client_alias = {
        port     = var.port
        dns_name = local.container_name
      }
      port_name      = local.container_name
      discovery_name = local.container_name
    }
  }

  security_group_rules = {
    service_ingress = {
      type = "ingress"
      from_port = var.port
      to_port   = var.port
      protocol  = "tcp"
      description = "Service port"
      cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
    monitor_ingress = {
      type = "ingress"
      from_port = var.monitor_port
      to_port   = var.monitor_port
      protocol  = "tcp"
      description = "Service port"
      cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
    egress_all = {
      type = "egress"
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name}-service"
  })
}
