resource "yandex_logging_group" "logging" {
  name             = "${local.service}-k8s-app-logging-group"
  folder_id        = local.folder_id
  retention_period = "720h"
}

resource "kubernetes_config_map" "logging" {
  metadata {
    name      = "fluent-bit-config"
    namespace = "logging"
    labels = {
      k8s-app = "fluent-bit"
    }
  }

  data = {
    "fluent-bit.conf"        = <<EOF
[SERVICE]
    Flush         1
    Log_Level     info
    Daemon        off
    Parsers_File  parsers.conf
    HTTP_Server   On
    HTTP_Listen   0.0.0.0
    HTTP_Port     2020

@INCLUDE input-kubernetes.conf
@INCLUDE filter-kubernetes.conf
@INCLUDE output-yc.conf
EOF
    "input-kubernetes.conf"  = <<EOF
[INPUT]
    Name              tail
    Tag               kube.*
    Path              /var/log/containers/*.log
    DB                /var/log/flb_kube.db
    Mem_Buf_Limit     5MB
    Skip_Long_Lines   On
#    multiline.parser  cri
    Parser  cri
EOF
    "filter-kubernetes.conf" = <<EOF
[FILTER]
    Name                kubernetes
    Match               kube.*
    Kube_URL            https://kubernetes.default.svc:443
    Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
    Kube_Tag_Prefix     kube.var.log.containers.
    Merge_Log           On
    Keep_Log            Off
    K8S-Logging.Parser  On
    K8S-Logging.Exclude Off

[FILTER]
    Name modify
    Match kube.*
    # Rename log.level severity
    # Rename log.levelname severity
    Rename $$message.msg msg
    Rename $$message.message msg
    # Rename message msg

[FILTER]
    Name     grep
    Match    *
    Exclude  log /ping

[FILTER]
    Name          rewrite_tag
    Match         kube.*
    Rule          $kubernetes['annotations']['yc.logging.tag'] ^(.+)$  yc.logging.$kubernetes['annotations']['yc.logging.tag'] false
    Emitter_Name  re_emitted
EOF
    "output-yc.conf"         = <<EOF
[OUTPUT]
    Name            yc-logging
    Match           kube.*
    group_id        $${LOG_GROUP_ID}
    resource_type   {kubernetes/namespace_name}
    resource_id     {kubernetes/container_name}
    stream_name     {kubernetes/labels/app}
    message_key     msg
    # level_key       severity
    default_level   DEBUG
    authorization   iam-key-file:/etc/secret/sa-key.json
EOF
    "parsers.conf"           = <<EOF
[PARSER]
    Name         cri
    Format       regex
    Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>[^ ]*) (?<message>.*)$
    Decode_Field_As json message
EOF
  }
}

resource "kubernetes_secret" "logging" {
  metadata {
    name      = "yc-logging"
    namespace = "logging"
  }

  data = {
    "sa-key.json" = jsonencode({
      id                 = yandex_iam_service_account_key.this["logging"].id
      service_account_id = yandex_iam_service_account.this["logging"].id
      created_at         = yandex_iam_service_account_key.this["logging"].created_at
      key_algorithm      = "RSA_4096"
      public_key         = yandex_iam_service_account_key.this["logging"].public_key
      private_key        = yandex_iam_service_account_key.this["logging"].private_key
    })
  }

  type = "kubernetes.io/generic"

  depends_on = [
    data.shell_script.kubeconfig,
  ]
}

# resource "kubernetes_network_policy" "logging" {
#   metadata {
#     name      = "yc-logging-fluent-bit-config"
#     namespace = "logging"
#   }

#   spec {
#     pod_selector {
#       match_labels = {
#         "k8s-app" = "fluent-bit"
#       }
#     }
#     policy_types = ["Egress"]
#     egress {
#       to {
# - ipBlock:
#     cidr: {{ . }}
#       }
#     }
#   }
# }

resource "kubernetes_service_account" "logging" {
  metadata {
    name      = "fluent-bit"
    namespace = "logging"
  }
}

resource "kubernetes_cluster_role_binding" "logging" {
  metadata {
    name = "fluent-bit-read"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fluent-bit-read"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.logging.metadata.0.name
    namespace = kubernetes_service_account.logging.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role" "logging" {
  metadata {
    name = "fluent-bit-read"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_daemonset" "logging" {
  metadata {
    name      = "yc-logging-controller"
    namespace = "logging"
    labels = {
      k8s-app                         = "fluent-bit-logging"
      version                         = "v1"
      "kubernetes.io/cluster-service" = "true"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "fluent-bit-logging"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app                         = "fluent-bit-logging"
          version                         = "v1"
          "kubernetes.io/cluster-service" = "true"
        }
      }

      spec {
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "fluent-bit-config"
          config_map {
            name = "fluent-bit-config"
          }
        }
        volume {
          name = "secret-key-json-volume"
          secret {
            secret_name = kubernetes_secret.logging.metadata.0.name
          }
        }

        container {
          name              = "fluent-bit"
          image             = "${local.cr_endpoint}/yc/fluent-bit-plugin-yandex:v2.0.3-fluent-bit-1.9.3"
          image_pull_policy = "Always"
          port {
            container_port = 2020
          }
          env {
            name  = "LOG_GROUP_ID"
            value = yandex_logging_group.logging.id
          }
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }
          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
          volume_mount {
            name       = "fluent-bit-config"
            mount_path = "/fluent-bit/etc/"
          }
          volume_mount {
            name       = "secret-key-json-volume"
            mount_path = "/etc/secret"
          }
          security_context {
            capabilities {
              drop = ["ALL"]
              add  = ["FOWNER"]
            }
            allow_privilege_escalation = false
          }
        }

        termination_grace_period_seconds = 10

        service_account_name = "fluent-bit"
        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        toleration {
          operator = "Exists"
          effect   = "NoExecute"
        }
        toleration {
          operator = "Exists"
          effect   = "NoSchedule"
        }
      }
    }
  }
}

# resource "helm_release" "logging" {
#   name = "yc-logging-helm-controller"

#   chart = "fluent-bit"

#   version    = "2.1.7-3"
#   repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/fluent-bit"

#   namespace        = "logging"
#   create_namespace = true
#   cleanup_on_fail  = true

#   set {
#     name  = "loggingGroupId"
#     value = yandex_logging_group.logging.id
#   }

#   set {
#     name  = "loggingFilter"
#     value = yandex_kubernetes_cluster.this.id
#   }

#   set {
#     name = "auth.json"
#     value = replace(replace(replace(replace(jsonencode({
#       id                 = yandex_iam_service_account_key.this["logging"].id
#       service_account_id = yandex_iam_service_account.this["logging"].id
#       created_at         = yandex_iam_service_account_key.this["logging"].created_at
#       key_algorithm      = "RSA_4096"
#       public_key         = yandex_iam_service_account_key.this["logging"].public_key
#       private_key        = yandex_iam_service_account_key.this["logging"].private_key
#       # fix helm chart error with missed escaping json
#     }), ",", "\\,"), "\\n", "\\\\n"), "{", "\\{"), "}", "\\}")
#   }

#   depends_on = [
#     data.shell_script.kubeconfig,
#   ]
# }

