# AWS Server Pool Module
A Terraform/OpenTofu module for creating an autoscaling server pool (e.g. for background workers) in AWS.

NOTE: This module is different from the [AWS Server Stack](https://github.com/strouptl/terraform-aws-server-stack) module, in that it does not include a public facing load balancer.

## Example Usage
Insert the following into your main.tf file:

    terraform {
      required_providers {
        aws = { 
          source  = "hashicorp/aws"
          version = "~> 5.17"
        }   
      }
      required_version = ">= 1.2.0"
    }
    
    provider "aws" {
      region  = "us-east-1"
    }
    
    module "example-server-pool" {
      source = "git@github.com:strouptl/terraform-aws-server-pool.git?ref=0.1.0"
      name = "example"
      desired_capacity = 2
      min_size = 1
      max_size = 4
      launch_template_id = "lt-0123456789"
    }

## Steps
1. Configure your desired EC2 instance, and then create an Image and a Launch Template for that image.
3. Plug your Launch Template into your server pool module as shown above


## Additional Options
1. vpc_id (defaults to the default VPC)
2. subnet_ids (defaults to all public subnets in the selected VPC)


## Example Usage: aws-security-groups

    terraform {
      required_providers {
        aws = { 
          source  = "hashicorp/aws"
          version = "~> 5.17"
        }   
      }
      required_version = ">= 1.2.0"
    }
    
    provider "aws" {
      region  = "us-east-1"
    }
    
    # Server Stack
    module "example-load-balancer" {
      source = "git@github.com:strouptl/terraform-aws-server-pool.git?ref=0.1.0"
      name = "example"
      desired_capacity = 2
      min_size = 1
      max_size = 4
      launch_template_id = "lt-0123456789"
      security_group_ids = [module.example_security_groups.load_balancers.id]
    }
