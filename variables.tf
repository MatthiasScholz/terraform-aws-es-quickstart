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
}

// NOTE: This variable has to be configured.
//       The default parameter is only used to tell terraform which type to expect.
variable "vpc_subnet_ids" {
  description = "Subnets the ES cluster should be created in."
  default     = []
}

variable "instance_type" {
  description = "Instance type to use for ES nodes and master"
  default     = "t2.small.elasticsearch"
}

variable "jump_ami" {
  description = "AMI to use for the jump station"
  default     = "ami-afd15ed0"                    // Amazon Linux 2 LTS ( amzn2-ami-hvm-2017.12.0.20180509-x86_64-gp2 )
}

variable "instance_key" {
  description = "Name of the ssh key to access the jump instance."
}
