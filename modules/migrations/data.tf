data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# Gather subnet info
data "aws_subnets" "vpc" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
