resource "kubernetes_service" "vue_service" {
  metadata {
    name = "vue_service"
    namespace = "default"
  }
  spec {
    selector {
      app = "vue_app"
    }
    session_affinity = "ClientIP"
    port {
      port = 4200
      target_port = 4200
    }

    # type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "vue_deployment" {
  metadata {
    name = "vue_deployment"
    namespace = "default"
    labels {
      app = "vue_app"
    }
  }

  spec {
    replicas = 1
    min_ready_seconds = 10

    selector {
      match_labels {
        app = "vue_app"
      }
    }

    template {
      metadata {
        labels {
          app = "vue_app",
          lang = "vue"
        }
      }

      spec {
        container {
          image = "$(var.docker_image):$(var.docker_image_tag)"
          image_pull_policy = "Always"
          name  = "vue_container"

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
