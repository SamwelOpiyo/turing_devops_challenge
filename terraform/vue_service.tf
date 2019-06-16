/*
This terraform script deploys https://github.com/SamwelOpiyo/Vue to gke cluster provisioned by main.tf in the default namespace.

A service is first provisioned with ClusterIP to expose the application internally.
Port exposed is port 5000 of the pod from target port 5000 of the container.
*/


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
      port        = 5000
      target_port = 5000
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
    replicas          = 3
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
