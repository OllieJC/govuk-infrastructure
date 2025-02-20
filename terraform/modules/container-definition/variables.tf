variable "aws_region" {
  type        = string
  description = "E.g. eu-west-1"
}

variable "command" {
  type        = list(any)
  description = "The command to pass to the container"
  default     = null
}

variable "environment_variables" {
  type        = map(any)
  default     = {}
  description = <<DESC
  A map of environment variables. For example { RAILS_ENV = "PRODUCTION", ... }
  Do not use this for secret values. Use secrets_from_arns to refer to secrets in SecretsManager instead.
DESC
}

variable "dependsOn" {
  type        = list(any)
  default     = []
  description = "See ECS Task Definition spec for dependsOn"
}

variable "healthcheck_command" {
  type        = list(string)
  description = "App container liveness healthcheck"
  default     = ["/bin/bash", "-c", "curl -f http://localhost:80/healthcheck/live || exit 1"]
}

variable "image" {
  type    = string
  default = null
}

variable "splunk_url_secret_arn" {
  type        = string
  description = "ARN to the secret containing the URL for the Splunk instance (of the form `https://http-inputs-XXXXXXXX.splunkcloud.com:PORT`)."
}

variable "splunk_token_secret_arn" {
  type        = string
  description = "ARN to the secret containing the HTTP Event Collector (HEC) token."
}

variable "splunk_index" {
  type        = string
  description = "Splunk index to log events to (which HEC token must have access to write to)."
}

variable "splunk_sourcetype" {
  type        = string
  default     = null
  description = "The source type of the logs being sent to Splunk i.e. `log4j`."
}

variable "name" {
  type        = string
  default     = "app"
  description = "Name for the container. Must match the associated ALB."
}

variable "ports" {
  type        = list(any)
  default     = [80]
  description = "The ports the application listens on. For most apps this can be left as the default (port 80)."
}

variable "secrets_from_arns" {
  type        = map(any)
  default     = {}
  description = <<DESC
  A map of secrets to AWS SecretsManager ARNs. For example { OAUTH_SECRET = "arn:aws:secretsmanager:eu-west-1:..." } # pragma: allowlist secret
DESC
}

variable "user" {
  type    = string
  default = null
}
