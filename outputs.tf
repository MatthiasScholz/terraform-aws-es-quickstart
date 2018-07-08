output "arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = "${module.es.arn}"
}

output "domain_name" {
  description = "Name of the AWS ES cluster"
  value       = "${var.domain_name}"
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = "${module.es.domain_id}"
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = "${module.es.endpoint}"
}

output "securitygroup" {
  description = "Security Group ID used to access the ES Cluster"
  value       = "${aws_security_group.es_allow_all.id}"
}

output "jump_dnsname" {
  description = "DNS name of the generated jump instances"
  value       = "${aws_instance.es_jump.public_dns}"
}
