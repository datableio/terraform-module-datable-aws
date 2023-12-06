#
# Define a TimescaleDB resource on ECS
#


#
# Service
#
module "timescale_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"
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

  # We do not want this service to auto-scale
  enable_autoscaling = false
  deployment_maximum_percent = 100

  #autoscaling_policies = { }
  #autoscaling_min_capacity = 1
  #autoscaling_max_capacity = 1

  container_definitions = {
    (local.container_name) = {
      cpu       = var.cpu
      memory    = var.memory
      essential = true

      image = var.image
      readonly_root_filesystem = false # TimescaleDB wants to create pid files

      mount_points = [
        {
          sourceVolume  = "${local.name}-data-efs"
          containerPath = "/var/lib/postgresql/data" # The path where PostgreSQL stores its data by default
        }
      ]

      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]

      environment = concat(local.env_vars, [
        {
          name  = "POSTGRES_PASSWORD"
          value = var.password
        },
        {
          name  = "POSTGRES_USER"
          value = var.username
        },
        {
          name  = "POSTGRES_DB"
          value = local.db_name
        }
      ])
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
    ingress = {
      type = "ingress"
      from_port = var.port
      to_port   = var.port
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

  volume = {
    "${local.name}-data-efs" = {
      efs_volume_configuration = {
        file_system_id = aws_efs_file_system.data.id
      }
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name}-service"
  })
}
