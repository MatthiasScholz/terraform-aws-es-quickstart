variable "deploy_profile" {
  description = "name of the aws-profile that should be used for deployment (i.e. playground)"
}

variable "region" {
  description = "region this stack should be applied to"
  default     = "us-east-2"
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.deploy_profile}"
}

### obtaining default vpc, security group and subnet of the env
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

module "es" {
  source         = "../../"
  region         = "${var.region}"
  domain_name    = "demo-es-vpc-tf"
  vpc_id         = "${data.aws_vpc.default.id}"
  vpc_subnet_ids = ["${element(data.aws_subnet_ids.all.ids,0)}"]
  instance_type  = "t2.small.elasticsearch"

  jump_ami     = "" #us-east-2: "ami-8c122be9", eu-central-1: "ami-afd15ed0"
  instance_key = ""
}
