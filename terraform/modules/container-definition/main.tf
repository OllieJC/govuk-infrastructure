output "json_format" {
  value = {
    name        = var.name,
    command     = var.command,
    essential   = true,
    environment = [for key, value in var.environment_variables : { name : key, value : tostring(value) }],
    dependsOn   = var.dependsOn
    healthCheck = {
      command     = var.healthcheck_command
      startPeriod = 30
      retries     = 5
    }
    image = var.image
    linuxParameters = {
      initProcessEnabled = true
    }
    logConfiguration = {
      logDriver = "splunk",
      options = {
        env               = "GOVUK_APP_NAME,GOVUK_CLUSTER,GOVUK_ENVIRONMENT",
        tag               = "image_name={{.ImageName}} container_name={{.Name}} container_id={{.FullID}}",
        splunk-sourcetype = var.splunk_sourcetype,
        splunk-index      = var.splunk_index,
        splunk-format     = "raw"
      }
      secretOptions = [
        {
          name      = "splunk-token",
          valueFrom = var.splunk_token_secret_arn
        },
        {
          name      = "splunk-url",
          valueFrom = var.splunk_url_secret_arn
        },
      ],
    },
    mountPoints  = [],
    portMappings = [for port in var.ports : { containerPort = port, hostPort = port, protocol = "tcp" }],
    secrets      = [for key, value in var.secrets_from_arns : { name = key, valueFrom = value }]
    user         = var.user
  }
}
