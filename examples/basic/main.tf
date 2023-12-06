provider "aws" {
  region = "us-west-2"
}

module "datable" {
  source = "../../"

  # Datable
  connect_key = "<TEST CONNECT KEY>"
}
