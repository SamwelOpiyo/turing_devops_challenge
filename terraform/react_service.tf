resource "kubernetes_service" "react-service" {
  metadata {
    name      = "react-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "react-app"
    }

    session_affinity = "ClientIP"

    port {
      port        = 5000
      target_port = 5000
    }

    # type = "LoadBalancer"
  }

  depends_on = [
    "null_resource.install-dependencies",
  ]
}

resource "kubernetes_deployment" "react-deployment" {
  metadata {
    name      = "react-deployment"
    namespace = "default"

    labels = {
      app = "react-app"
    }
  }

  spec {
    replicas          = 1
    min_ready_seconds = 10

    selector {
      match_labels = {
        app = "react-app"
      }
    }

    template {
      metadata {
        labels = {
          app  = "react-app"
          lang = "react"
        }
      }

      spec {
        container {
          image             = "${var.react_docker_image}"
          image_pull_policy = "Always"
          name              = "react-container"

          resources {
            limits {
              cpu    = "0.2"
              memory = "200Mi"
            }

            requests {
              cpu    = "0.1m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    "null_resource.install-dependencies",
    "kubernetes_service.react-service",
  ]
}
