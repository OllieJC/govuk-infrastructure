terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.69"
    }
  }
}

# TODO: remove the redundant `_service` suffixes; they make it tedious to refer
# to outputs e.g. in security_group_rules.tf.
module "frontend_service" {
  appmesh_mesh_govuk_id                    = aws_appmesh_mesh.govuk.id
  govuk_publishing_platform_namespace_id   = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.id
  govuk_publishing_platform_namespace_name = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.name
  task_role_arn                            = aws_iam_role.task.arn
  execution_role_arn                       = aws_iam_role.execution.arn
  vpc_id                                   = var.vpc_id
  cluster_id                               = aws_ecs_cluster.cluster.id
  source                                   = "../../modules/apps/frontend"
}

module "publisher_service" {
  appmesh_mesh_govuk_id                    = aws_appmesh_mesh.govuk.id
  govuk_publishing_platform_namespace_id   = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.id
  govuk_publishing_platform_namespace_name = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.name
  publishing_api_ingress_security_group    = module.publishing_api_service.security_group_id
  task_role_arn                            = aws_iam_role.task.arn
  execution_role_arn                       = aws_iam_role.execution.arn
  vpc_id                                   = var.vpc_id
  cluster_id                               = aws_ecs_cluster.cluster.id
  source                                   = "../../modules/apps/publisher"
}

module "content_store_service" {
  appmesh_mesh_govuk_id                    = aws_appmesh_mesh.govuk.id
  govuk_publishing_platform_namespace_id   = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.id
  govuk_publishing_platform_namespace_name = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.name
  publishing_api_ingress_security_group    = module.publishing_api_service.security_group_id
  task_role_arn                            = aws_iam_role.task.arn
  execution_role_arn                       = aws_iam_role.execution.arn
  vpc_id                                   = var.vpc_id
  cluster_id                               = aws_ecs_cluster.cluster.id
  source                                   = "../../modules/apps/content-store"
}

module "publishing_api_service" {
  appmesh_mesh_govuk_id                    = aws_appmesh_mesh.govuk.id
  govuk_publishing_platform_namespace_id   = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.id
  govuk_publishing_platform_namespace_name = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.name
  task_role_arn                            = aws_iam_role.task.arn
  execution_role_arn                       = aws_iam_role.execution.arn
  vpc_id                                   = var.vpc_id
  cluster_id                               = aws_ecs_cluster.cluster.id
  source                                   = "../../modules/apps/publishing-api"
}
