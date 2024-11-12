locals {
  zitadel_data_api_env = local.is_zitadel_enabled ? [
    {
      name  = "AUTH_TYPE"
      value = "ZITADEL"
    },
    {
      name  = "AUTH_BASE_URL"
      value = "https://zitadel.${local.domain}"
    },
    {
      name        = "AUTH_PROJECT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "ZITADEL_PROJECT_ID"
    },
    {
      name        = "AUTH_CLIENT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "BI_SERVICE_CLIENT_ID"
    },
    {
      name        = "AUTH_CLIENT_SECRET"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "BI_SERVICE_CLIENT_SECRET"
    },
    {
      name        = "AUTH_APP_CLIENT_ID"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "DL_CLIENT_ID"
    },
    {
      name        = "AUTH_APP_CLIENT_SECRET"
      secret_name = "k8s-lockbox-zitadel-secret"
      secret_key  = "DL_CLIENT_SECRET"
    },
  ] : []
}

resource "kubernetes_deployment" "data-api" {
  metadata {
    name = "data-api"
    labels = {
      app = "app-data-api"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-data-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-data-api"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-data-api:${local.data_api_version}"
          name  = "app-data-api"
          port {
            container_port = 8080
          }

          # FIXME: after backend 401 public route fix
          # liveness_probe {
          #   http_get {
          #     path = "/ping"
          #     port = 8080
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 5
          #   timeout_seconds       = 10

          #   success_threshold = 1
          #   failure_threshold = 3
          # }

          # readiness_probe {
          #   http_get {
          #     path = "/ping_ready"
          #     port = 8080
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 5
          #   timeout_seconds       = 10

          #   success_threshold = 1
          #   failure_threshold = 3
          # }

          resources {
            limits = {
              cpu    = "2"
              memory = "2048Mi"
            }
            requests = {
              cpu    = "1"
              memory = "1024Mi"
            }
          }
          env {
            name  = "GUNICORN_WORKERS_COUNT"
            value = "5"
          }
          env {
            name  = "RQE_FORCE_OFF"
            value = "1"
          }
          env {
            name  = "CACHES_ON"
            value = "0"
          }
          env {
            name  = "MUTATIONS_CACHES_ON"
            value = "0"
          }
          env {
            name  = "RQE_SECRET_KEY"
            value = ""
          }
          env {
            name  = "DL_CRY_ACTUAL_KEY_ID"
            value = "key_2"
          }
          # temp key to allow resave demo connection
          dynamic "env" {
            for_each = local.is_add_demo_crypto_key ? ["main"] : []

            content {
              name  = "DL_CRY_KEY_VAL_ID_key_1"
              value = "h1ZpilcYLYRdWp7Nk8X1M1kBPiUi8rdjz9oBfHyUKIk="
            }
          }
          env {
            name = "DL_CRY_KEY_VAL_ID_key_2"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "CONTROL_API_CRYPTO_KEY"
              }
            }
          }
          env {
            name  = "BI_COMPENG_PG_ON"
            value = "1"
          }
          env {
            name = "BI_COMPENG_PG_URL"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "PG_DSN_CLUSTER_COMPENG"
              }
            }
          }
          env {
            name  = "US_HOST"
            value = "http://us-cip:8083"
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
            for_each = local.zitadel_data_api_env

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

resource "kubernetes_service" "data-api_service" {
  metadata {
    name = "data-api-cip"
  }
  spec {
    selector = {
      app = "app-data-api"
    }
    port {
      name        = "http"
      port        = 8081
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
