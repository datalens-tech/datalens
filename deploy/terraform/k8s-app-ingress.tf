resource "kubernetes_ingress_v1" "k8s_ingress" {
  metadata {
    name = "k8s-ingress"
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
      hosts       = local.is_zitadel_enabled ? [local.domain, "zitadel.${local.domain}"] : [local.domain]
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
      for_each = local.is_zitadel_enabled ? ["main"] : []

      content {
        host = "zitadel.${local.domain}"
        http {
          path {
            backend {
              service {
                name = "zitadel-np"
                port {
                  number = 8085
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
}
