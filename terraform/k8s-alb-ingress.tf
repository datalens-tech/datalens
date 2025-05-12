resource "yandex_vpc_address" "this" {
  name = "${local.service}-k8s-alb-ingress-ip"

  external_ipv4_address {
    zone_id = local.zones[0]
  }
}

resource "helm_release" "alb_ingress" {
  name = "yc-alb-ingress-controller"

  chart = "yc-alb-ingress-controller-chart"

  version    = "v0.2.23"
  repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/yc-alb-ingress"

  namespace        = "alb-ingress"
  create_namespace = true
  cleanup_on_fail  = true

  values = [yamlencode({
    folderId  = local.folder_id
    clusterId = yandex_kubernetes_cluster.this.id
    saKeySecretKey = jsonencode({
      id                 = yandex_iam_service_account_key.this["alb"].id
      service_account_id = yandex_iam_service_account.this["alb"].id
      created_at         = yandex_iam_service_account_key.this["alb"].created_at
      key_algorithm      = "RSA_4096"
      public_key         = yandex_iam_service_account_key.this["alb"].public_key
      private_key        = yandex_iam_service_account_key.this["alb"].private_key
    })
  })]

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
}

locals {
  # access to alb from public net
  v4_any_cidr_blocks = ["0.0.0.0/0"]
  ingress_alb = [
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "TCP", target = "loadbalancer_healthchecks", port = 30080, desc = "alb" },
    { proto = "TCP", cidr_v4 = local.v4_any_cidr_blocks, port = 80, desc = "http" },
    { proto = "TCP", cidr_v4 = local.v4_any_cidr_blocks, port = 443, desc = "https" },
  ]
  egress_alb = [
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "TCP", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 32767, desc = "subnets" },
  ]
}

resource "yandex_vpc_security_group" "alb" {
  name       = "${local.service}-alb-sg"
  network_id = yandex_vpc_network.this.id

  dynamic "ingress" {
    for_each = local.ingress_alb

    content {
      protocol          = ingress.value.proto
      v4_cidr_blocks    = try(ingress.value.cidr_v4, [])
      predefined_target = try(ingress.value.target, null)
      port              = try(ingress.value.port, null)
      from_port         = try(ingress.value.from_port, null)
      to_port           = try(ingress.value.to_port, null)
      description       = try(ingress.value.desc, null)
    }
  }

  dynamic "egress" {
    for_each = local.egress_alb

    content {
      protocol          = egress.value.proto
      v4_cidr_blocks    = try(egress.value.cidr_v4, [])
      predefined_target = try(egress.value.target, null)
      port              = try(egress.value.port, null)
      from_port         = try(egress.value.from_port, null)
      to_port           = try(egress.value.to_port, null)
      description       = try(egress.value.desc, null)
    }
  }
}

resource "yandex_cm_certificate" "this" {
  name    = "${local.service}-k8s-alb-ingress-cert"
  domains = local.is_create_wildcard_certificate ? ["*.${local.domain}", local.domain] : [local.domain]

  managed {
    challenge_type  = "DNS_CNAME"
    challenge_count = 1
  }
}

locals {
  alb_ipv4_address = yandex_vpc_address.this.external_ipv4_address[0].address

  dns_records = concat([
    {
      key  = "cert-0"
      name = yandex_cm_certificate.this.challenges[0].dns_name,
      type = yandex_cm_certificate.this.challenges[0].dns_type,
      data = yandex_cm_certificate.this.challenges[0].dns_value
    },
    {
      key  = "domain-0"
      name = "${local.domain}.",
      type = "A",
      data = local.alb_ipv4_address
    }
    ], local.is_create_wildcard_certificate ? [
    {
      key  = "domain-1"
      name = "*.${local.domain}.",
      type = "A",
      data = local.alb_ipv4_address
    }
  ] : [])
}

resource "yandex_dns_zone" "this" {
  for_each = toset(local.is_create_dns_zone ? ["main"] : [])

  name = "${local.service}-dns-zone"

  zone   = "${local.domain}."
  public = true
}

resource "yandex_dns_recordset" "this" {
  depends_on = [
    yandex_cm_certificate.this
  ]

  for_each = local.is_create_dns_zone ? { for r in local.dns_records : r.key => r } : {}

  zone_id = yandex_dns_zone.this["main"].id
  name    = each.value.name
  type    = each.value.type
  data    = [each.value.data]
  ttl     = 600
}
