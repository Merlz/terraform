provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_creds}"
  profile                 = "${var.aws_profile}"
}

data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "git::git@github.com:Merlz/tf-modules.git//terraform-aws-jenkins?ref=master"
  namespace   = "${var.label_namespace}"
  name        = "${var.label_name}"
  stage       = "${var.label_stage}"
  description = "${var.label_description}"

  master_instance_type         = "${var.jen_instance_type}"
  aws_account_id               = "${var.aws_account}"
  aws_region                   = "${var.aws_region}"
  availability_zones           = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  vpc_id                       = "${module.vpc.vpc_id}"
  zone_id                      = "${var.aws_route53_zone}"
  public_subnets               = "${module.subnets.public_subnet_ids}"
  private_subnets              = "${module.subnets.private_subnet_ids}"
  loadbalancer_certificate_arn = "${var.aws_cert_arn}"
  ssh_key_pair                 = "${var.aws_ec2_ssh_keypair}"

  build_image         = "${var.jen_build_image}"
  solution_stack_name = "${var.jen_stack_name}"

  github_oauth_token  = "${var.jen_git_token}"
  github_organization = "${var.jen_git_org}"
  github_repo_name    = "${var.jen_git_repo}"
  github_branch       = "${var.jen_git_branch}"

  datapipeline_config = {
    instance_type = "${var.pipe_instance_type}"
    email         = "${var.pipe_email}"
    period        = "${var.pipe_period}"
    timeout       = "${var.pipe_timeout}"
  }

  # env_default_value = "prod"

  env_vars = {
    JENKINS_USER          = "${var.jen_env_user}"
    JENKINS_PASS          = "${var.jen_env_pass}"
    JENKINS_NUM_EXECUTORS = "${var.jen_env_num_exec}"
  }
}

module "vpc" {
  source     = "git::git@github.com:Merlz/tf-modules.git//terraform-aws-vpc?ref=master"
  namespace  = "${var.label_namespace}"
  name       = "${var.label_name}"
  stage      = "${var.label_stage}"
  cidr_block = "${var.vpc_cidr}"
}

module "subnets" {
  source              = "git::git@github.com:Merlz/tf-modules.git//terraform-aws-dynamic-subnets?ref=master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "${var.label_namespace}"
  name                = "${var.label_name}"
  stage               = "${var.label_stage}"
  region              = "${var.aws_region}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "${var.nat_enabled}"
}
