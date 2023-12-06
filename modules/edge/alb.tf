module "alb" {
  count = var.create_alb ? 1 : 0

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "${var.stack_name}-${local.name}"
  load_balancer_type = "application"

  vpc_id  = data.aws_vpc.vpc.id
  subnets = var.public_subnets

  enable_deletion_protection = false

  # Security Group
  create_security_group = true # Have to have something
  security_groups       = var.alb_security_groups

  security_group_ingress_rules = {
    all_http = {
      from_port   = var.port
      to_port     = var.port
      ip_protocol = "tcp"
      cidr_ipv4   = coalesce(var.alb_security_group_cidr, data.aws_vpc.vpc.cidr_block) # Default allow Datable to talk to itself via ALB
    }
  }

  security_group_egress_rules  = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = data.aws_vpc.vpc.cidr_block
    }
  }

  listeners = {
    otel_http = {
      port     = var.port
      protocol = "HTTP"

      forward = {
        target_group_key = "edge"
      }
    }
  }

  target_groups = {
    edge = {
      port                              = var.port
      backend_protocol                  = "HTTP"
      backend_port                      = local.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/healthz"
        port                = var.monitor_port
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name}-service"
  })
}
