locals {
  zitadel_us_env = local.is_zitadel_enabled ? [
    {
      name  = "ZITADEL"
      value = "true"
    },
    {
      name  = "ZITADEL_URI"
      value = "https://zitadel.${local.domain}"
    },
    {
      name        = "SERVICE_CLIENT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "US_SERVICE_CLIENT_ID"
    },
    {
      name        = "SERVICE_CLIENT_SECRET"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "US_SERVICE_CLIENT_SECRET"
    },
    {
      name        = "CLIENT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "DL_CLIENT_ID"
    },
    {
      name        = "CLIENT_SECRET"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "DL_CLIENT_SECRET"
    },
  ] : []
}

resource "kubernetes_deployment" "us" {
  metadata {
    name = "us"
    labels = {
      app = "app-us"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-us"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-us"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-us:${local.us_version}"
          name  = "app-us"

          port {
            container_port = 8083
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8083
            }

            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 10

            success_threshold = 1
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path = "/ping-db"
              port = 8083
            }

            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 10

            success_threshold = 1
            failure_threshold = 3
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "1"
              memory = "512Mi"
            }
          }

          env {
            name  = "APP_INSTALLATION"
            value = "opensource"
          }
          env {
            name  = "APP_ENV"
            value = "prod"
          }
          env {
            name = "MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          env {
            name = "POSTGRES_DSN_LIST"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "PG_DSN_LIST_US"
              }
            }
          }
          env {
            name  = "SKIP_INSTALL_DB_EXTENSIONS"
            value = "1"
          }
          env {
            name  = "USE_DEMO_DATA"
            value = local.is_install_demo_data ? "1" : "0"
          }
          dynamic "env" {
            for_each = local.zitadel_us_env

            content {
              name  = env.value.name
              value = try(env.value.value, null)

              dynamic "value_from" {
                for_each = try(env.value.secret_name, null) != null ? ["main"] : []

                content {
                  secret_key_ref {
                    name = env.value.secret_name
                    key  = env.value.secret_key
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "us_service" {
  metadata {
    name = "us-cip"
  }
  spec {
    selector = {
      app = "app-us"
    }
    port {
      name        = "http"
      port        = 8083
      target_port = 8083
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
