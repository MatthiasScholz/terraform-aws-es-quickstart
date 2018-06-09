variable "profile" {
  description = "AWS profile to use"
  default     = "playground"
}

variable "region" {
  description = "AWS region to use"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC"
  default     = "vpc-bf440ad9" // default vpc
}

variable "subnet_ids" {
  description = "Subnets the ES cluster should be created in."
  default     = ["subnet-bf8ee983"]
}

variable "instance_type" {
  description = "Instance type to use for ES nodes and master"
  default     = "t2.small.elasticsearch"
}

variable "jump_ami" {
  description = "AMI to use for the jump station"
  default     = "ami-afd15ed0"                    // Amazon Linux 2 LTS ( amzn2-ami-hvm-2017.12.0.20180509-x86_64-gp2 )
}

variable "ssh_key" {
  description = "Name of the ssh key to access the jump instance."
  default     = "kp-us-east-1-playground-instancekey.pem"
}
