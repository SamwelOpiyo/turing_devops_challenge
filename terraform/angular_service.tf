resource "kubernetes_service" "angular_service" {
  metadata {
    name = "angular_service"
    namespace = "default"
  }
  spec {
    selector {
      app = "angular_app"
    }
    session_affinity = "ClientIP"
    port {
      port = 4200
      target_port = 4200
    }

    # type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "angular_deployment" {
  metadata {
    name = "angular_deployment"
    namespace = "default"
    labels {
      app = "angular_app"
    }
  }

  spec {
    replicas = 1
    min_ready_seconds = 10

    selector {
      match_labels {
        app = "angular_app"
      }
    }

    template {
      metadata {
        labels {
          app = "angular_app",
          lang = "angular"
        }
      }

      spec {
        container {
          image = "$(var.docker_image):$(var.docker_image_tag)"
          image_pull_policy = "Always"
          name  = "angular_container"

          resources{
            limits{
              cpu    = "0.2"
              memory = "200Mi"
            }
            requests{
              cpu    = "0.1m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}
