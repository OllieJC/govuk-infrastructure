ecs_default_capacity_provider = "FARGATE_SPOT"

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

govuk_environment      = "test"

# TODO: Could this be named more clearly?
public_domain          = "govuk.digital"
root_public_zone_id    = "Z0724382Y412668RNID"
public_lb_domain_name  = "test.govuk.digital"
internal_domain_name   = "test.govuk-internal.digital"
govuk_aws_state_bucket = "govuk-terraform-steppingstone-test"
