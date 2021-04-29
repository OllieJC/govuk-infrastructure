output "private_subnets" {
  value = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids
}

output "frontend_security_groups" {
  value       = module.frontend.security_groups
  description = "Used by ECS RunTask to run short-lived tasks with the same SG permissions as the frontend ECS Service."
}

output "content-store" {
  value = {
    draft = {
      task_definition_cli_input_json = module.draft_content_store.cli_input_json,
      network_config                 = module.draft_content_store.network_config
    },
    live = {
      task_definition_cli_input_json = module.content_store.cli_input_json,
      network_config                 = module.content_store.network_config
    },
  }
}

output "publisher" {
  value = {
    web = {
      task_definition_cli_input_json = module.publisher_web.cli_input_json,
      network_config                 = module.publisher_web.network_config
    },
    worker = {
      task_definition_cli_input_json = module.publisher_worker.cli_input_json,
      network_config                 = module.publisher_worker.network_config
    },
  }
}

output "frontend" {
  value = {
    draft = {
      task_definition_cli_input_json = module.draft_frontend.cli_input_json,
      network_config                 = module.draft_frontend.network_config
    },
    live = {
      task_definition_cli_input_json = module.frontend.cli_input_json,
      network_config                 = module.frontend.network_config
    },
  }
}

output "publishing-api" {
  value = {
    web = {
      task_definition_cli_input_json = module.publishing_api_web.cli_input_json,
      network_config                 = module.publishing_api_web.network_config
    },
    worker = {
      task_definition_cli_input_json = module.publishing_api_worker.cli_input_json,
      network_config                 = module.publishing_api_worker.network_config
    },
  }
}

output "smokey" {
  value = {
    default = {
      task_definition_cli_input_json = module.smokey_task_definition.cli_input_json,
      network_config                 = module.smokey_network_config.network_config
    }
  }
}

output "log_group" {
  value = local.log_group
}

output "mesh_name" {
  value = aws_appmesh_mesh.govuk.name
}

output "mesh_domain" {
  value = local.mesh_domain
}

output "external_app_domain" {
  value = local.workspace_external_domain
}

output "internal_app_domain" {
  value = var.internal_app_domain
}

output "govuk_website_root" {
  value = "https://frontend.${local.workspace_external_domain}" # TODO: Change back to www once router is up
}

output "fargate_execution_iam_role_arn" {
  value = aws_iam_role.execution.arn
}

output "fargate_task_iam_role_arn" {
  value = aws_iam_role.task.arn
}

output "signon" {
  value = {
    web = {
      task_definition_cli_input_json = module.signon.cli_input_json,
      network_config                 = module.signon.network_config
    }
  }
}

output "signon_bootstrap_command" {
  # TODO: Make publishing_service_domain workspace-aware once OAuth applications done
  value = "bundle exec rake bootstrap:all[${var.publishing_service_domain}${local.is_default_workspace ? "" : ",${terraform.workspace}"}]"
}

output "static" {
  value = {
    draft = {
      task_definition_cli_input_json = module.draft_static.cli_input_json,
      network_config                 = module.draft_static.network_config
    },
    live = {
      task_definition_cli_input_json = module.static.cli_input_json,
      network_config                 = module.static.network_config
    },
  }
}

output "router-api" {
  value = {
    draft = {
      task_definition_cli_input_json = module.draft_router_api.cli_input_json,
      network_config                 = module.draft_router_api.network_config
    },
    live = {
      task_definition_cli_input_json = module.router_api.cli_input_json,
      network_config                 = module.router_api.network_config
    },
  }
}

output "router" {
  value = {
    draft = {
      task_definition_cli_input_json = module.draft_router.cli_input_json,
      network_config                 = module.draft_router.network_config
    },
    live = {
      task_definition_cli_input_json = module.router.cli_input_json,
      network_config                 = module.router.network_config
    },
  }
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
