resource "kubernetes_job" "postgresql_demo_data" {
  for_each = toset(
    local.k8s_cluster_ready &&
    local.is_create_demo_db &&
    local.is_create_demo_data
  ? ["main"] : [])

  metadata {
    name      = "postgres-demo-data"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    template {
      metadata {
        name = "postgres-demo-data"
      }
      spec {
        container {
          name    = "postgres-demo-data"
          image   = "ghcr.io/datalens-tech/datalens-postgres:16"
          command = ["/init/seed-demo-data.sh"]
          env {
            name = "CONTROL_API_CRYPTO_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "CONTROL_API_CRYPTO_KEY"
              }
            }
          }
          env {
            name = "POSTGRES_PASSWORD_US"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_PASSWORD_US"
              }
            }
          }
          env {
            name = "POSTGRES_PASSWORD_DEMO"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_PASSWORD_DEMO"
              }
            }
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8080"
          }
          env {
            name  = "POSTGRES_HOST"
            value = local.pg_cluster_host
          }
          env {
            name  = "POSTGRES_PORT"
            value = local.pg_cluster_port
          }
          env {
            name  = "POSTGRES_USER_US"
            value = local.pg_us_user
          }
          env {
            name  = "POSTGRES_DB_US"
            value = replace(local.pg_us_user, "-user", "-db")
          }
          env {
            name  = "POSTGRES_USER_DEMO"
            value = local.pg_demo_user
          }
          env {
            name  = "POSTGRES_DB_DEMO"
            value = replace(local.pg_demo_user, "-user", "-db")
          }
        }
        restart_policy = "OnFailure"
      }
    }
    backoff_limit           = 5
    active_deadline_seconds = 600
  }
}
