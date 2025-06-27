resource "kubernetes_deployment" "temporal" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "temporal"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "temporal"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "temporal"
      }
    }
    template {
      metadata {
        labels = {
          app = "temporal"
        }
      }
      spec {
        container {
          image             = "ghcr.io/datalens-tech/datalens-temporal:1.27.2"
          image_pull_policy = "Always"
          name              = "temporal"

          port {
            container_port = 7233
          }

          resources {
            limits = {
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "256Mi"
            }
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
            name  = "POSTGRES_USER"
            value = local.pg_temporal_user
          }
          env {
            name  = "POSTGRES_DB"
            value = replace(local.pg_temporal_user, "-user", "-db")
          }
          env {
            name  = "POSTGRES_DB_VISIBILITY"
            value = replace(local.pg_temporal_user, "-user", "-visibility-db")
          }
          env {
            name  = "POSTGRES_TLS_ENABLED"
            value = "true"
          }
          env {
            name  = "POSTGRES_TLS_DISABLE_HOST_VERIFICATION"
            value = "false"
          }
          env {
            name  = "NAMESPACES"
            value = "meta-manager"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_PASSWORD_TEMPORAL"
              }
            }
          }
          env {
            name  = "TEMPORAL_AUTH_ENABLED"
            value = "true"
          }
          env {
            name = "TEMPORAL_AUTH_PUBLIC_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "TEMPORAL_AUTH_PUBLIC_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "temporal_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "temporal-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "temporal"
    }
    port {
      name        = "http"
      port        = 7233
      target_port = 7233
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
