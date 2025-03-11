locals {
  gh_owner = "datalens-tech"
  gh_label = "datalens-opensource"

  runner_ssh_access = false

  runner_os_image = "ubuntu-2404-lts-oslogin"
  runner_version  = "2.319.1"

  runners_count = 3
  runners_ids   = local.is_create_github_runner ? [for i in range(0, local.runners_count) : { key = "ind-${i}", ind = i }] : []
}

resource "yandex_lockbox_secret" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  name = "${local.service}-github-runner-secrets"
}

resource "yandex_iam_service_account" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  name = "${local.service}-gh-runner-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  folder_id = local.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.github-runner["main"].id}"
}

resource "yandex_lockbox_secret_iam_binding" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  secret_id = yandex_lockbox_secret.github-runner["main"].id
  role      = "lockbox.payloadViewer"

  members = [
    "serviceAccount:${yandex_iam_service_account.github-runner["main"].id}",
  ]
}

data "yandex_compute_image" "this" {
  family = local.runner_os_image
}

resource "yandex_vpc_address" "github-runner" {
  for_each = local.runner_ssh_access ? { for id in local.runners_ids : id.key => id.ind } : {}

  name = "github-runner-${each.key}-ip"

  external_ipv4_address {
    zone_id = local.zones[each.value % length(local.zones)]
  }
}

resource "yandex_compute_disk" "github-runner" {
  for_each = { for id in local.runners_ids : id.key => id.ind }

  name     = "github-runner-${each.key}-disk"
  type     = "network-ssd"
  size     = 200
  zone     = local.zones[each.value % length(local.zones)]
  image_id = data.yandex_compute_image.this.id

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "yandex_compute_instance" "github-runner" {
  for_each = { for id in local.runners_ids : id.key => id.ind }

  name        = "github-runner-${local.gh_label}-${each.key}"
  platform_id = "standard-v3"
  zone        = local.zones[each.value % length(local.zones)]

  allow_stopping_for_update = true

  service_account_id = yandex_iam_service_account.github-runner["main"].id

  resources {
    cores  = 8
    memory = 16
  }

  boot_disk {
    disk_id     = yandex_compute_disk.github-runner[each.key].id
    auto_delete = false
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this[local.zones[each.value % length(local.zones)]].id
    security_group_ids = [yandex_vpc_security_group.github-runner["main"].id]
    ipv4               = true

    nat            = local.runner_ssh_access
    nat_ip_address = local.runner_ssh_access ? yandex_vpc_address.github-runner[each.key].external_ipv4_address[0].address : null
  }

  metadata = {
    skip_update_ssh_keys = true
    enable-oslogin       = true

    user-data = templatefile("github-runner-config.yaml", {
      VERSION = local.runner_version

      OWNER = local.gh_owner
      LABEL = local.gh_label
      IND   = "${each.value}"

      LOCKBOX_ID  = yandex_lockbox_secret.github-runner["main"].id
      LOCKBOX_KEY = "RUNNER_${upper(replace(local.gh_label, "-", "_"))}_${each.value}_TOKEN"
    })
  }
}

locals {
  v4_gh_git_cidr_blocks    = [for cidr in sort(distinct(concat(local.github_meta["git"]))) : cidr if strcontains(cidr, ":") == false]
  v4_gh_common_cidr_blocks = [for cidr in sort(distinct(concat(local.github_meta["importer"], local.github_meta["hooks"], local.github_meta["web"]))) : cidr if strcontains(cidr, ":") == false]

  # security groups limit [limit vpc.securityGroupRuleCidrs.count exceeded]
  # v4_gh_actions_cidr_blocks = [for cidr in sort(distinct([for c in local.github_meta["actions"] : join(".", slice(split(".", c), 0, 2)) if strcontains(c, ":") == false])) : "${cidr}.0.0/16"]
  # v4_gh_actions_cidr_blocks = [for cidr in sort(distinct(concat(local.github_meta["actions"], local.github_meta["web"]))) : cidr if strcontains(cidr, ":") == false]

  ubuntu_apt_endpoint          = "archive.ubuntu.com"
  ubuntu_apt_security_endpoint = "security.ubuntu.com"
  gh_pipelinse_endpoint        = "pipelines.actions.githubusercontent.com"
  gh_vstoken_endpoint          = "vstoken.actions.githubusercontent.com"

  common_endpoints = [
    local.ubuntu_apt_endpoint,
    local.ubuntu_apt_security_endpoint,
  ]
  gh_endpoints = [
    local.gh_pipelinse_endpoint,
    local.gh_vstoken_endpoint,
  ]
}

data "dns_a_record_set" "github-runner-common" {
  for_each = toset(local.common_endpoints)

  host = each.key
}

data "dns_a_record_set" "github-runner-gh" {
  for_each = toset(local.gh_endpoints)

  host = each.key
}

locals {
  v4_gh_any_cidr_blocks = ["0.0.0.0/0"]

  ingress_github_runner = concat([
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
    { proto = "ICMP", cidr_v4 = local.v4_icmp_cidr_blocks, from_port = 0, to_port = 65535, desc = "icmp" },
  ], local.runner_ssh_access ? [{ proto = "TCP", cidr_v4 = ["${local.v4_public_ip}/32"], port = 22, desc = "ssh" }] : [])
  egress_github_runner = concat(
    [
      { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
      { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
      { proto = "ICMP", cidr_v4 = local.v4_icmp_cidr_blocks, from_port = 0, to_port = 65535, desc = "icmp" },
      { proto = "TCP", cidr_v4 = local.v4_gh_api_cidr_blocks, port = 443, desc = "github api" },
      { proto = "TCP", cidr_v4 = local.v4_gh_common_cidr_blocks, port = 443, desc = "github common" },
      { proto = "TCP", cidr_v4 = local.v4_gh_git_cidr_blocks, port = 22, desc = "github git ssh" },
      { proto = "TCP", cidr_v4 = local.v4_gh_git_cidr_blocks, port = 443, desc = "github git https" },
      { proto = "TCP", cidr_v4 = local.v4_gh_any_cidr_blocks, port = 443, desc = "any" },
      { proto = "TCP", cidr_v4 = local.v4_gh_any_cidr_blocks, port = 80, desc = "any" },
    ],
    [for e in local.endpoints : { proto = "TCP", cidr_v4 = ["${data.dns_a_record_set.this[e].addrs[0]}/32"], port = 443, desc = e }],
    [for e in local.gh_endpoints : { proto = "TCP", cidr_v4 = ["${data.dns_a_record_set.github-runner-gh[e].addrs[0]}/32"], port = 443, desc = e }],
    [for e in local.common_endpoints : { proto = "TCP", cidr_v4 = ["${data.dns_a_record_set.github-runner-common[e].addrs[0]}/32"], port = 80, desc = e }],
    [for e in local.common_endpoints : { proto = "TCP", cidr_v4 = ["${data.dns_a_record_set.github-runner-common[e].addrs[0]}/32"], port = 443, desc = e }],
  )
}

resource "yandex_vpc_security_group" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  name       = "${local.service}-github-runner-sg"
  network_id = yandex_vpc_network.this.id

  dynamic "ingress" {
    for_each = local.ingress_github_runner

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
    for_each = local.egress_github_runner

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
