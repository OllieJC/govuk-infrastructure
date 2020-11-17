variable "vpc_id" {
  type = string
}

variable "mesh_domain" {
  type = string
}

variable "mesh_name" {
  type = string
}

variable "private_subnets" {
  description = "Subnet IDs to use for non-Internet-facing resources."
  type        = list
}

variable "public_subnets" {
  description = "Subnet IDs to use for Internet-facing resources."
  type        = list
}

variable "public_lb_domain_name" {
  description = "Domain in which to create DNS records for Internet-facing load balancers. For example, staging.govuk.digital"
  type        = string
}

variable "govuk_management_access_sg_id" {
  description = "ID of security group (from the govuk-aws repo) for access from jumpboxes etc. This SG is added to all ECS instances."
  type        = string
}

variable "postgresql_security_group_id" {
  description = "ID of security group (from the govuk-aws repo) for the shared Postgres RDS."
  type        = string
}

variable "redis_security_group_id" {
  description = "ID of security group (from the govuk-aws repo) for the shared Redis."
  type        = string
}

variable "documentdb_security_group_id" {
  description = "ID of security group (from the govuk-aws repo) for the shared DocumentDB."
  type        = string
}

variable "mongodb_security_group_id" {
  description = "ID of security group (from the govuk-aws repo) for the shared MongoDB."
  type        = string
}

variable "frontend_desired_count" {
  description = "Desired count of Frontend Application instances"
  type        = number
}

variable "content_store_desired_count" {
  description = "Desired count of Frontend Application instances"
  type        = number
}

variable "static_desired_count" {
  description = "Desired count of Static Application instances"
  type        = number
}

variable "office_cidrs_list" {
  description = "List of GDS office CIDRs"
  type        = list
  default     = ["213.86.153.212/32", "213.86.153.213/32", "213.86.153.214/32", "213.86.153.235/32", "213.86.153.236/32", "213.86.153.237/32", "85.133.67.244/32"]
}
