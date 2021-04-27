resource "aws_secretsmanager_secret" "signon_admin_password" {
  name                    = "signon_admin_password_${local.workspace}" # pragma: allowlist secret
  recovery_window_in_days = 0
}

# TODO: Replace the random_password approach with an autogenerate_secret module
# that runs a rotation lambda to createSecret.
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.signon_admin_password.id
  secret_string = random_password.signon_admin_password.result
}

resource "random_password" "signon_admin_password" {
  length  = 64
  special = true
}

#
# Signon bearer tokens
#

locals {
  # TODO: This isn't right.
  signon_api_url = "signon.${local.workspace}.${var.govuk_environment}.govuk.digital/api/v1"

  api_user_prefix = terraform.workspace == "default" ? null : local.workspace
  signon_app = {
    content_store       = "Content Store"
    draft_content_store = "Draft Content Store"
    frontend            = "Frontend"
    publisher           = "Publisher"
    publishing_api      = "Publishing API"
    router_api          = "Router API"
  }
  signon_api_user = {
    content_store       = join("-", compact([local.api_user_prefix, "content-store@digital.cabinet-office.gov.uk"]))
    draft_content_store = join("-", compact([local.api_user_prefix, "draft-content-store@digital.cabinet-office.gov.uk"]))
    frontend            = join("-", compact([local.api_user_prefix, "frontend@digital.cabinet-office.gov.uk"]))
    publisher           = join("-", compact([local.api_user_prefix, "publisher@digital.cabinet-office.gov.uk"]))
    publishing_api      = join("-", compact([local.api_user_prefix, "publishing-api@digital.cabinet-office.gov.uk"]))
  }
}

module "publisher_to_publishing_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.publisher
  app_name                        = local.signon_app.publishing_api
  name                            = "pub_to_pub_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "publishing_api_to_content_store_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.publishing_api
  app_name                        = local.signon_app.content_store
  name                            = "pub_api_to_cs"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "publishing_api_to_draft_content_store_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.publishing_api
  app_name                        = local.signon_app.draft_content_store
  name                            = "pub_api_to_dcs"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "publishing_api_to_router_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.publishing_api
  app_name                        = local.signon_app.router_api
  name                            = "pub_api_to_router_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "frontend_to_publishing_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.frontend
  app_name                        = local.signon_app.publishing_api
  name                            = "frontend_to_pub_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "content_store_to_publishing_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.content_store
  app_name                        = local.signon_app.publishing_api
  name                            = "cs_to_pub_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "draft_content_store_to_publishing_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.draft_content_store
  app_name                        = local.signon_app.publishing_api
  name                            = "dcs_to_pub_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "content_store_to_router_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.content_store
  app_name                        = local.signon_app.router_api
  name                            = "cs_to_router_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}

module "draft_content_store_to_router_api_bearer_token" {
  source = "../../modules/signon_bearer_token"

  api_user_email                  = local.signon_api_user.draft_content_store
  app_name                        = local.signon_app.router_api
  name                            = "dcs_to_router_api"
  private_subnets                 = local.private_subnets
  signon_admin_password_arn       = aws_secretsmanager_secret.signon_admin_password.arn
  signon_host                     = module.signon.virtual_service_name
  signon_lambda_security_group_id = aws_security_group.signon_lambda.id
  workspace                       = local.workspace
}
