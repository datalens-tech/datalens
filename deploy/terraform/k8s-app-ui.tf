locals {
  zitadel_ui_env = local.is_zitadel_enabled ? [
    {
      name  = "ZITADEL"
      value = "true"
    },
    {
      name  = "ZITADEL_URI"
      value = "https://zitadel.${local.domain}"
    },
    {
      name  = "ZITADEL_INTERNAL_URI"
      value = "https://zitadel.${local.domain}"
    },
    {
      name  = "APP_HOST_URI"
      value = "https://${local.domain}"
    },
    {
      name        = "ZITADEL_COOKIE_SECRET"
      secret_name = "k8s-lockbox-secret"
      secret_key  = "ZITADEL_COOKIE_SECRET"
    },
    {
      name        = "ZITADEL_PROJECT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "ZITADEL_PROJECT_ID"
    },
    {
      name        = "SERVICE_CLIENT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "CHARTS_SERVICE_CLIENT_ID"
    },
    {
      name        = "SERVICE_CLIENT_SECRET"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "CHARTS_SERVICE_CLIENT_SECRET"
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

resource "kubernetes_deployment" "ui" {
  metadata {
    name = "ui"
    labels = {
      app = "app-ui"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-ui"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-ui:${local.ui_version}"
          name  = "app-ui"

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8080
            }

            initial_delay_seconds = 3
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
            value = "production"
          }
          env {
            name  = "APP_MODE"
            value = "full"
          }
          env {
            name  = "AUTH_POLICY"
            value = "disabled"
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8083"
          }
          env {
            name  = "BI_API_ENDPOINT"
            value = "http://control-api-cip:8082"
          }
          env {
            name  = "BI_DATA_ENDPOINT"
            value = "http://data-api-cip:8081"
          }
          env {
            name = "US_MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          dynamic "env" {
            for_each = local.zitadel_ui_env

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

resource "kubernetes_service" "ui_service" {
  metadata {
    name = "ui-np"
  }
  spec {
    selector = {
      app = "app-ui"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      node_port   = 30080
    }
    type = "NodePort"
  }
}
