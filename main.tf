# Input
variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
  default = ""
}
variable "launch_template_id" {
  type = string
}
variable "subnet_ids" {
  type = list
  default = []
}
variable "desired_capacity" {
  type = string
}
variable "max_size" {
  type = string
}
variable "min_size" {
  type = string
}

# VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_vpc" "selected" {
  id = (var.vpc_id == "" ? data.aws_vpc.default.id : var.vpc_id)
}

# Subnets
module "default_subnets" {
  source = "git@github.com:strouptl/terraform-aws-subnets-fetcher.git"
}

locals {
  subnet_ids = (var.subnet_ids == [] ? module.default_subnets.ids : var.subnet_ids)
}

# Autoscaling Group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "default" {
  name               = var.name
  vpc_zone_identifier = local.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 120
  default_cooldown          = 60
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size


  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}
