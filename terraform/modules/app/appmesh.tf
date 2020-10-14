locals {
  virtual_service_name = "${var.service_name}.${var.service_discovery_namespace_name}"
}

resource "aws_appmesh_virtual_service" "service" {
  name      = local.virtual_service_name
  mesh_name = var.mesh_name

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.service.name
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "service" {
  name      = var.service_name
  mesh_name = var.mesh_name

  spec {
    backend {
      virtual_service {
        virtual_service_name = local.virtual_service_name
      }
    }

    listener {
      port_mapping {
        port     = var.container_ingress_port
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        namespace_name = var.service_discovery_namespace_name
        service_name   = aws_service_discovery_service.service.name
      }
    }
  }

  depends_on = [aws_service_discovery_service.service]
}
