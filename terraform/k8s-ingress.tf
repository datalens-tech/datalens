resource "kubernetes_ingress_v1" "k8s_ingress" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "k8s-ingress"
    namespace = kubernetes_namespace.this.metadata[0].name
    annotations = {
      "ingress.alb.yc.io/subnets"               = join(",", local.subnet_ids)
      "ingress.alb.yc.io/security-groups"       = yandex_vpc_security_group.alb.id
      "ingress.alb.yc.io/external-ipv4-address" = local.alb_ipv4_address
      "ingress.alb.yc.io/group-name"            = "alb-ingress-group"
      "ingress.alb.yc.io/upgrade-types"         = "WebSocket"
    }
  }

  spec {
    tls {
      hosts = concat(
        [local.domain],
        local.is_create_wildcard_certificate ? ["*.${local.domain}"] : [],
        local.k8s_argo_cd ? ["argocd.${local.domain}"] : [],
      )
      secret_name = "yc-certmgr-cert-id-${yandex_cm_certificate.this.id}"
    }

    rule {
      host = local.domain
      http {
        path {
          backend {
            service {
              name = "ui-np"
              port {
                number = 8080
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }
      }
    }

    dynamic "rule" {
      for_each = toset(local.k8s_argo_cd ? ["main"] : [])

      content {
        host = "argocd.${local.domain}"
        http {
          path {
            backend {
              service {
                name = "argo-cd-argocd-server"
                port {
                  number = 80
                }
              }
            }

            path      = "/"
            path_type = "Prefix"
          }
        }
      }
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
}
