variable "vpc_id" {
  type = string
}

variable "cluster_id" {
  description = "ECS cluster to deploy into."
  type        = string
}

# TODO: improve name/description (private_subnet_ids or perhaps just subnet_ids, depending on how it's really being used)
variable "private_subnets" {
  description = "The subnet ids for govuk_private_a, govuk_private_b, and govuk_private_c"
  type        = list
}

# TODO: improve name
variable "appmesh_mesh_govuk_id" {
  type    = string
  default = "govuk"
}

variable "govuk_publishing_platform_namespace_id" {
  type = string
}

variable "govuk_publishing_platform_namespace_name" {
  type = string
}

variable "service_name" {
  description = "Name to use for the ECS service, task and other resources. Should normally be the name of the app."
  type        = string
}

variable "container_definitions" {
  description = "List of ECS ContainerDefinitions for the app, as maps in HCL/JSON syntax (not strings). The module adds the Envoy sidecar to this list."
  type        = list
}

variable "container_ingress_port" {
  description = "Port on which the app container accepts connections."
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of instances of the ECS task."
  type        = number
  default     = 1
}

variable "task_role_arn" {
  description = "ARN of IAM role for the app's ECS task to talk to other AWS services."
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of IAM role for the ECS container agent and Docker daemon to manage the app container."
  type        = string
}

variable "extra_security_groups" {
  description = "Additional security groups to attach to the app's ECS service/tasks."
  type        = list
  default     = []
}
