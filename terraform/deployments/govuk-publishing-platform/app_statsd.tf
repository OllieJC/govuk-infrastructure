module "statsd" {
  cluster_id                       = aws_ecs_cluster.cluster.id
  execution_role_arn               = aws_iam_role.execution.arn
  internal_app_domain              = var.internal_app_domain
  mesh_name                        = aws_appmesh_mesh.govuk.id
  private_subnets                  = local.private_subnets
  security_groups                  = [aws_security_group.mesh_ecs_service.id, local.govuk_management_access_sg_id]
  service_discovery_namespace_id   = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.id
  service_discovery_namespace_name = aws_service_discovery_private_dns_namespace.govuk_publishing_platform.name
  source                           = "../../modules/statsd"
  task_role_arn                    = aws_iam_role.task.arn
  vpc_id                           = local.vpc_id
}

