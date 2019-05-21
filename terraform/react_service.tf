resource "kubernetes_service" "react_service" {
  metadata {
    name = "react_service"
    namespace = "default"
  }
  spec {
    selector {
      app = "react_app"
    }
    session_affinity = "ClientIP"
    port {
      port = 4200
      target_port = 4200
    }

    # type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "react_deployment" {
  metadata {
    name = "react_deployment"
    namespace = "default"
    labels {
      app = "react_app"
    }
  }

  spec {
    replicas = 1
    min_ready_seconds = 10

    selector {
      match_labels {
        app = "react_app"
      }
    }

    template {
      metadata {
        labels {
          app = "react_app",
          lang = "react"
        }
      }

      spec {
        container {
          image = "$(var.docker_image):$(var.docker_image_tag)"
          image_pull_policy = "Always"
          name  = "react_container"

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
