resource "kubernetes_service" "vue-service" {
  metadata {
    name      = "vue-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "vue-app"
    }

    session_affinity = "ClientIP"

    port {
      port        = 8080
      target_port = 8080
    }

    # type = "LoadBalancer"
  }

  depends_on = [
    "null_resource.install-dependencies",
  ]
}

resource "kubernetes_deployment" "vue-deployment" {
  metadata {
    name      = "vue-deployment"
    namespace = "default"

    labels = {
      app = "vue-app"
    }
  }

  spec {
    replicas          = 1
    min_ready_seconds = 10

    selector {
      match_labels = {
        app = "vue-app"
      }
    }

    template {
      metadata {
        labels = {
          app  = "vue-app"
          lang = "vue"
        }
      }

      spec {
        container {
          image             = "${var.vue_docker_image}"
          image_pull_policy = "Always"
          name              = "vue-container"

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
    "kubernetes_service.vue-service",
  ]
}
