data "kubernetes_service" "nginx-ingress-controller" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "nginx-ingress"
  }

  depends_on = [
    "kubernetes_ingress.turing-devops-ingress",
  ]
}

resource "kubernetes_ingress" "turing-devops-ingress" {
  metadata {
    name      = "turing-devops-ingress"
    namespace = "default"

    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"

      # "kubernetes.io/tls-acme"                   = "true"
      # "certmanager.k8s.io/cluster-issuer"        = "letsencrypt-prod"
      # "certmanager.k8s.io/acme-challenge-type"   = "http01"
    }
  }

  spec {
    rule {
      # host = "turing.samwelopiyo.guru"

      http {

        path {
          backend {
            service_name = "vue-service"
            service_port = 5000
          }

          path = "/"
        }
      }
    }

    rule {
      host = "angular.turing.samwelopiyo.guru"
      http {
        path {
          backend {
            service_name = "angular-service"
            service_port = 5000
          }
          path = "/"
        }
      }
    }

    rule {
      host = "react.turing.samwelopiyo.guru"
      http {
        path {
          backend {
            service_name = "react-service"
            service_port = 5000
          }
          path = "/"
        }
      }
    }

    rule {
      host = "vue.turing.samwelopiyo.guru"
      http {
        path {
          backend {
            service_name = "vue-service"
            service_port = 5000
          }
          path = "/"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
      hosts       = [
        "turing.samwelopiyo.guru",
        "vue.turing.samwelopiyo.guru",
        "angular.turing.samwelopiyo.guru",
        "react.turing.samwelopiyo.guru",
      ]
    }
  }

  depends_on = [
    "null_resource.install-dependencies",
    "kubernetes_service.react-service",
    "kubernetes_service.angular-service",
    "kubernetes_service.vue-service",
  ]
}
