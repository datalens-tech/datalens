locals {
  zitadel_image = "ghcr.io/zitadel/zitadel:v${local.zitadel_version}"
  zitadel_env = local.is_zitadel_enabled ? [
    {
      name  = "ZITADEL_DATABASE_POSTGRES_HOST"
      value = "c-${yandex_mdb_postgresql_cluster.this.id}.rw.mdb.yandexcloud.net"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_PORT"
      value = "6432"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_DATABASE"
      value = yandex_mdb_postgresql_database.this[local.pg_zitadel_user].name
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_ADMIN_EXISTINGDATABASE"
      value = yandex_mdb_postgresql_database.this[local.pg_zitadel_user].name
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_USER_SSL_MODE"
      value = "disable"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_ADMIN_SSL_MODE"
      value = "disable"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_USER_USERNAME"
      value = local.pg_zitadel_user
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_ADMIN_USERNAME"
      value = local.pg_zitadel_user
    },
    {
      name        = "ZITADEL_DATABASE_POSTGRES_USER_PASSWORD"
      secret_name = "k8s-lockbox-secret"
      secret_key  = "PG_PASSWORD_ZITADEL"
    },
    {
      name        = "ZITADEL_DATABASE_POSTGRES_ADMIN_PASSWORD"
      secret_name = "k8s-lockbox-secret"
      secret_key  = "PG_PASSWORD_ZITADEL"
    },
    {
      name        = "ZITADEL_MASTERKEY"
      secret_name = "k8s-lockbox-secret"
      secret_key  = "ZITADEL_MASTERKEY"
    },
    {
      name  = "ZITADEL_FIRSTINSTANCE_ORG_HUMAN_USERNAME"
      value = "admin@datalens"
    },
    {
      name        = "ZITADEL_FIRSTINSTANCE_ORG_HUMAN_PASSWORD"
      secret_name = "k8s-lockbox-secret"
      secret_key  = "ZITADEL_ROOT_PASSWORD"
    },
    #config
    {
      name  = "ZITADEL_SYSTEMDEFAULTS_SECRETGENERATORS_PASSWORDSALTCOST"
      value = "1"
    },
    {
      name  = "ZITADEL_EXTERNALSECURE"
      value = "true"
    },
    {
      name  = "ZITADEL_TLS_ENABLED"
      value = "false"
    },
    {
      name  = "ZITADEL_EXTERNALPORT"
      value = "443"
    },
    {
      name  = "ZITADEL_EXTERNALDOMAIN"
      value = "zitadel.${local.domain}"
    },
    {
      name  = "ZITADEL_DEFAULTINSTANCE_OIDCSETTINGS_ACCESSTOKENLIFETIME"
      value = "0.25h"
    },
    {
      name  = "ZITADEL_DEFAULTINSTANCE_OIDCSETTINGS_REFRESHTOKENEXPIRATION"
      value = "336h"
    },
    {
      name  = "ZITADEL_FIRSTINSTANCE_ORG_HUMAN_PASSWORDCHANGEREQUIRED"
      value = "false"
    },
    {
      name  = "ZITADEL_MACHINE_IDENTIFICATION_WEBHOOK_ENABLED"
      value = "false"
    },
    {
      name  = "ZITADEL_MACHINE_IDENTIFICATION_HOSTNAME_ENABLED"
      value = "true"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_MAXOPENCONNS"
      value = "20"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_MAXIDLECONNS"
      value = "10"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_MAXCONNLIFETIME"
      value = "30m"
    },
    {
      name  = "ZITADEL_DATABASE_POSTGRES_MAXCONNIDLETIME"
      value = "10m"
    }
  ] : []
}

resource "kubernetes_deployment" "zitadel" {
  for_each = toset(local.is_zitadel_enabled ? ["main"] : [])

  metadata {
    name = "zitadel"
    labels = {
      app = "app-zitadel"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-zitadel"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-zitadel"
        }
      }
      spec {
        container {
          image = "ghcr.io/zitadel/zitadel:v${local.zitadel_version}"
          name  = "app-zitadel"

          args = ["start", "--masterkeyFromEnv"]

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/debug/healthz"
              port = 8080
              http_header {
                name  = "Host"
                value = "zitadel.${local.domain}"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 10

            success_threshold = 1
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path = "/debug/ready"
              port = 8080
              http_header {
                name  = "Host"
                value = "zitadel.${local.domain}"
              }
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
              memory = "1048Mi"
            }
            requests = {
              cpu    = "1"
              memory = "512Mi"
            }
          }

          env {
            name = "POD_IP"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }

          dynamic "env" {
            for_each = local.zitadel_env

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

resource "kubernetes_job" "zitadel_init_job" {
  for_each = toset(local.is_zitadel_enabled && local.is_zitadel_need_init_job_run ? ["main"] : [])

  metadata {
    name = "zitadel-init-job"
  }
  spec {
    ttl_seconds_after_finished = "600"

    template {
      metadata {
        name = "zitadel-init-job"
      }
      spec {
        container {
          name  = "zitadel-init-job"
          args  = ["init", "zitadel"]
          image = local.zitadel_image

          dynamic "env" {
            for_each = local.zitadel_env

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
        restart_policy = "OnFailure"
      }
    }

    backoff_limit           = 5
    active_deadline_seconds = 600
  }
}

resource "kubernetes_job" "zitadel_setup_job" {
  for_each = toset(local.is_zitadel_enabled && local.is_zitadel_need_init_job_run ? ["main"] : [])

  metadata {
    name = "zitadel-setup-job"
  }
  spec {
    ttl_seconds_after_finished = "600"

    template {
      metadata {
        name = "zitadel-setup-job"
      }
      spec {
        container {
          name  = "zitadel-setup-job"
          args  = ["setup", "--init-projections=true", "--masterkeyFromEnv"]
          image = local.zitadel_image

          dynamic "env" {
            for_each = local.zitadel_env

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
        restart_policy = "OnFailure"
      }
    }

    backoff_limit           = 5
    active_deadline_seconds = 600
  }
}

resource "kubernetes_service" "zitadel_service" {
  for_each = toset(local.is_zitadel_enabled ? ["main"] : [])

  metadata {
    name = "zitadel-np"
  }
  spec {
    selector = {
      app = "app-zitadel"
    }
    port {
      name        = "http"
      port        = 8085
      target_port = 8080
      protocol    = "TCP"
      node_port   = 30085
    }
    type = "NodePort"
  }
}
