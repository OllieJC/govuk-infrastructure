terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

locals {
  virtual_node_name = var.service_name

  container_definitions = [
    {
      "name" : "envoy",
      # TODO: don't hardcode the version; track stable Envoy
      # TODO: control when Envoy updates happen (but still needs to be automatic)
      # TODO: don't hardcode the region
      "image" : "840364872350.dkr.ecr.eu-west-1.amazonaws.com/aws-appmesh-envoy:v1.16.1.0-prod",
      "user" : "1337",
      "environment" : [
        {
          "name" : "APPMESH_RESOURCE_ARN",
          "value" : "arn:aws:appmesh:us-west-1:430354129336:mesh/${var.mesh_name}/virtualNode/${local.virtual_node_name}"
        },
      ],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "awslogs-fargate",
          "awslogs-region" : "eu-west-1", # TODO: hardcoded
          "awslogs-stream-prefix" : "awslogs-${var.service_name}-envoy"
        }
      }
    }
  ]
}

resource "aws_ecs_task_definition" "definition" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode(concat(var.container_definitions, local.container_definitions))
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"

    properties = {
      AppPorts         = var.container_ingress_ports
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254" # TODO: no longer required (try omitting, might need to stay but empty?)
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}
