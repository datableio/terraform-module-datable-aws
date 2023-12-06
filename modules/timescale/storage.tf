#
# EFS Persistent storage
#

resource "aws_efs_file_system" "data" {
  creation_token = "${local.name}-data-efs"
  encrypted = true

  tags = merge(local.tags, {
    Name = "timescale-data-efs"
   })
}

resource "aws_efs_mount_target" "data" {
 for_each = { for k, v in zipmap(local.azs, local.storage_subnet_ids) : k => v }

 file_system_id = aws_efs_file_system.data.id
 security_groups = [aws_security_group.timescale_data_efs.id]
 subnet_id      = each.value
}

resource "aws_security_group" "timescale_data_efs" {
  name        = "${local.name}-efs_security_group"
  description = "Allow inbound traffic to EFS"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name}-efs_security_group"
  })
}

resource "aws_security_group_rule" "efs_security_group_ingress" {
  security_group_id = aws_security_group.timescale_data_efs.id

  type        = "ingress"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  source_security_group_id = module.timescale_service.security_group_id
}
