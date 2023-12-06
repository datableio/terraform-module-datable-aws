provider "aws" {
  region = "us-west-2"
}

module "datable" {
  source = "../../"

  connect_key         = "<TEST CONNECT KEY>"
  switchboard_url     = "wss://switchboard.datable.io"
  environment         = "staging"
  stack_name          = "datable"
  vpc_cidr            = "172.16.0.0/12"
  single_nat_gateway  = true
  create_alb          = true
  alb_security_groups = [
    "sg-614ff9ae2fc1cb5d6d53", # Some random sg, do not use this.
  ]

  # DANGER! Don't let the world write to your instance...
  #alb_security_group_cidr = "0.0.0.0/0"
}
