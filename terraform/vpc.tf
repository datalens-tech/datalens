# vpc

resource "yandex_vpc_network" "this" {
  name = "${local.service}-nets"
}

locals {
  zones = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

resource "yandex_vpc_gateway" "this" {
  name = "${local.service}-gateway-nat"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "this" {
  name       = "${local.service}-route-table-nat"
  network_id = yandex_vpc_network.this.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.this.id
  }
}

resource "yandex_vpc_subnet" "this" {
  for_each = toset(local.zones)

  name = "${local.service}-net-${each.key}"
  zone = each.key

  v4_cidr_blocks = ["10.${index(local.zones, each.key) + 11}.0.0/16"]

  network_id     = yandex_vpc_network.this.id
  route_table_id = yandex_vpc_route_table.this.id
}

locals {
  lockbox_endpoint     = "lockbox.${local.api_endpoint}"
  lockbox_dpl_endpoint = replace(local.api_endpoint, "api.", "public-dpl.lockbox.")
  logging_endpoint     = "ingester.logging.yandexcloud.net"
  endpoints = [
    local.api_endpoint,
    local.storage_endpoint,
    local.cr_endpoint,
    local.lockbox_endpoint,
    local.lockbox_dpl_endpoint,
    local.logging_endpoint
  ]
}

data "dns_a_record_set" "this" {
  for_each = toset(local.endpoints)

  host = each.key
}

data "http" "this" {
  for_each = local.k8s_use_external_ipv4 && !local.k8s_connect_by_internal_ipv4 ? { ip = "https://api.ipify.org", github = "https://api.github.com/meta" } : { github = "https://api.github.com/meta" }

  url = each.value
}

locals {
  subnet_ids = [for z in local.zones : yandex_vpc_subnet.this[z].id]

  v4_subnets_cidr_blocks = flatten([for z in local.zones : yandex_vpc_subnet.this[z].v4_cidr_blocks])
  v4_k8s_cidr_blocks     = ["10.96.0.0/16", "10.112.0.0/16"]
  v4_k8s_any_cidr_blocks = ["0.0.0.0/0"]
  v4_icmp_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  github_meta            = jsondecode(data.http.this["github"].response_body)
  v4_gh_api_cidr_blocks  = [for cidr in sort(distinct(concat(local.github_meta["packages"], local.github_meta["api"]))) : cidr if strcontains(cidr, ":") == false]
  v4_public_ip           = try(data.http.this["ip"].response_body, "")

  ingress = concat([
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
    { proto = "ANY", cidr_v4 = local.v4_k8s_cidr_blocks, from_port = 0, to_port = 65535, desc = "k8s" },
    { proto = "ICMP", cidr_v4 = local.v4_icmp_cidr_blocks, from_port = 0, to_port = 65535, desc = "icmp" },
    { proto = "TCP", target = "loadbalancer_healthchecks", from_port = 0, to_port = 65535, desc = "alb" },
    ], local.k8s_use_external_ipv4 && !local.k8s_connect_by_internal_ipv4 && !local.k8s_allow_from_public_net ? [{ proto = "TCP", cidr_v4 = ["${local.v4_public_ip}/32"], port = 443, desc = "deploy" }] : [],
  local.k8s_use_external_ipv4 && local.k8s_allow_from_public_net ? [{ proto = "TCP", cidr_v4 = ["0.0.0.0/0"], port = 443, desc = "public" }] : [])
  egress = concat(
    [
      { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
      { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
      { proto = "ANY", cidr_v4 = local.v4_k8s_cidr_blocks, from_port = 0, to_port = 65535, desc = "k8s" },
      { proto = "TCP", cidr_v4 = local.v4_gh_api_cidr_blocks, port = 443, desc = "github api" },
    ],
    [for e in local.endpoints : { proto = "TCP", cidr_v4 = ["${data.dns_a_record_set.this[e].addrs[0]}/32"], port = 443, desc = e }],
    local.k8s_monitoring ? [{ proto = "TCP", cidr_v4 = local.v4_k8s_any_cidr_blocks, port = 443, desc = "any" }] : [],
  )
}

resource "yandex_vpc_security_group" "this" {
  name       = "${local.service}-k8s-sg"
  network_id = yandex_vpc_network.this.id

  dynamic "ingress" {
    for_each = local.ingress

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
    for_each = local.egress

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
