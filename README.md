# Datable on AWS Terraform Module

## Usage

```hcl
provider "aws" {
  region = var.region
}

module "datable" {
  source = "github.com/datableio/terraform-module-datable"
  
  # Datable
  connect_key = "<TEST CONNECT KEY>"
}
```

## Overview

The datable AWS module performs the following steps:
* Creates a new VPC to contain Datable
* Create required database instances
* Create an ECS Cluster for deployment
* Deploys Datable


## Examples

* [Basic Usage](examples/basic/)
* [Full Config](examples/full/)


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Version |
|------|---------|
| terraform-aws-modules/ecs/aws | >= 5.7.3 |
| terraform-aws-modules/rds/aws | >= 6.3.0 |
| terraform-aws-modules/vpc/aws | >= 5.2.0 |


## Resources

| Name | Type |
|------|------|


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `connect_key` | Connect Key used to connect to Datable | `string` | `null` | yes |  
| `switchboard_url` | Endpoint URL for connecting to Datable | `string` | `"wss://switchboard.datable.io"` | no |
| `environment` | Environment tag to apply to created resources | `string` | `"production"` | no |
| `stack_name` | Name prefix used in creating the stack | `string` | `"datable"` | no |
| `vpc_cidr` | Network range used when creating the VPC | `string` | `"192.168.0.0/16"` | no |
| `single_nat_gateway` | If enabled, create a single shared NAT gateway for all AZs | `bool` | `false` | no |
| `create_alb` | Create an application load balancer for accepting traffic | `bool` | `true` | no |
| `alb_security_groups` | Security groups that will be allowed to send data to the ALB | `list(string)` | `[]` | no |
| `alb_security_group_cidr` | CIDR that will be allowed access to the ALB. NOT ADVISED, use `alb_security_groups` instead. | `string` | `""` | no |


## Outputs

| Name | Description |
|------|-------------|
| `otel_host` | DNS name of the endpoint for sending OTEL data to Datable |
