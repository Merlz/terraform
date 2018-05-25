## AWS

variable "aws_region" {}
variable "aws_creds" {}
variable "aws_profile" {}
variable "aws_account" {}

variable "max_availability_zones" {}

variable "aws_route53_zone" {}
variable "aws_cert_arn" {}
variable "aws_ec2_ssh_keypair" {}

## NAMESPACE => Module terraform-null-label

variable "label_namespace" {}
variable "label_name" {}
variable "label_stage" {}
variable "label_description" {}
variable "jen_git_branch" {}

## GITHUB

variable "jen_git_token" {}
variable "jen_git_org" {}
variable "jen_git_repo" {}

## JENKINS MODULE

variable "jen_instance_type" {}
variable "jen_build_image" {}
variable "jen_stack_name" {}
variable "jen_env_user" {}
variable "jen_env_pass" {}
variable "jen_env_num_exec" {}

## DATA PIPELINE MODULE

variable "pipe_instance_type" {}
variable "pipe_email" {}
variable "pipe_period" {}
variable "pipe_timeout" {}

## VPC MODULE

variable "vpc_cidr" {}

## SUBNET MODULE

variable "nat_enabled" {}
