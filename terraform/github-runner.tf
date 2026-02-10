locals {
  gh_endpoint = "api.github.com"

  gh_owner = "datalens-tech"
  gh_label = "datalens-opensource"
  gh_group = "opensource"

  runner_ssh_access = false

  runner_os_image = "ubuntu-2404-lts-oslogin"
  runner_version  = "2.331.0"

  node_version       = "22"
  task_version       = "3.48.0"
  awscli_version     = "2.33.17"
  yc_version         = "0.191.0"
  playwright_version = "1.48.2"
  opentofu_version   = "1.8.4"
  kubectl_version    = "1.31.5"
  helm_version       = "3.17.1"
  yq_version         = "4.45.1"
  trivy_version      = "0.69.0"
  shfmt_version      = "3.12.0"
  shellcheck_version = "0.10.0"
  yamlfmt_version    = "0.17.2"

  runners_count = 9
  runners_ids   = local.is_create_github_runner ? [for i in range(0, local.runners_count) : { key = "ind-${i}", ind = i }] : []

  runners_recreate_counter = 0 # for force recreate if config was not changed

  runner_lockbox_key = "GITHUB_RUNNER_TOKEN"
  runner_config = templatefile("github-runner-config.yaml", {
    VERSION = local.runner_version

    NODE_VERSION       = local.node_version
    TASK_VERSION       = local.task_version
    AWSCLI_VERSION     = local.awscli_version
    YC_VERSION         = local.yc_version
    PLAYWRIGHT_VERSION = local.playwright_version
    OPENTOFU_VERSION   = local.opentofu_version
    KUBECTL_VERSION    = local.kubectl_version
    HELM_VERSION       = local.helm_version
    YQ_VERSION         = local.yq_version
    TRIVY_VERSION      = local.trivy_version
    SHFMT_VERSION      = local.shfmt_version
    SHELLCHECK_VERSION = local.shellcheck_version
    YAMLFMT_VERSION    = local.yamlfmt_version

    OWNER = local.gh_owner
    LABEL = local.gh_label
    IND   = "#IND#"

    RUNNER_GROUP = local.gh_group

    LOCKBOX_ID  = yandex_lockbox_secret.github-runner["main"].id
    LOCKBOX_KEY = local.runner_lockbox_key
  })
  runner_config_hash = sha1(local.runner_config)
}

resource "yandex_lockbox_secret" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  name = "${local.service}-github-runner-secrets"
}

data "yandex_lockbox_secret_version" "github-runner" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  secret_id = yandex_lockbox_secret.github-runner["main"].id
}

locals {
  gh_app_private_key = try({
    for v in(
      data.yandex_lockbox_secret_version.github-runner["main"].entries != null
      ? data.yandex_lockbox_secret_version.github-runner["main"].entries : []
    ) : v.key => v.text_value
  }["GITHUB_APP_PRIVATE_KEY"], "<empty>")
  gh_app_id = try({
    for v in(
      data.yandex_lockbox_secret_version.github-runner["main"].entries != null
      ? data.yandex_lockbox_secret_version.github-runner["main"].entries : []
    ) : v.key => v.text_value
  }["GITHUB_APP_ID"], "<empty>")
}

resource "terraform_data" "github-runner-config" {
  input = {
    runner_config            = local.runner_config
    runner_config_hash       = local.runner_config_hash
    runners_recreate_counter = local.runners_recreate_counter
  }

  triggers_replace = [
    local.runner_config_hash,
    local.runners_recreate_counter
  ]
}

resource "terraform_data" "github-runner-token" {
  input = {
    runners_count            = local.runners_count
    runner_config_hash       = local.runner_config_hash
    runners_recreate_counter = local.runners_recreate_counter
  }

  triggers_replace = [
    local.runners_count,
    local.runner_config_hash,
    local.runners_recreate_counter
  ]
}

resource "time_static" "now" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  rfc3339 = timestamp()

  lifecycle {
    ignore_changes = [
      rfc3339
    ]
    replace_triggered_by = [
      terraform_data.github-runner-token
    ]
  }
}

resource "jwt_signed_token" "github-runner-jwt-token" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 && local.gh_app_private_key != "" ? ["main"] : [])

  algorithm = "RS256"
  claims_json = jsonencode({
    "iss" = local.gh_app_id,
    "iat" = time_static.now["main"].unix,
    "exp" = time_static.now["main"].unix + 10 * 60, // 10 min
  })
  key = local.gh_app_private_key
}

locals {
  gh_app_jwt_token = try(jwt_signed_token.github-runner-jwt-token["main"].token, "")
}

resource "terracurl_request" "github-runner-installation" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  name           = "github-runner-installation"
  response_codes = ["200", "201"]
  url            = "https://${local.gh_endpoint}/orgs/${local.gh_owner}/installation"
  method         = "GET"

  headers = {
    Accept        = "application/json"
    Authorization = sensitive("Bearer ${local.gh_app_jwt_token}")
  }

  ignore_response_fields = [
    "access_tokens_url",
    "account",
    "app_id",
    "app_slug",
    "client_id",
    "created_at",
    "html_url",
    "permissions",
    "repositories_url",
    "repository_selection",
    "target_id",
    "target_type",
  ]
}

locals {
  gh_app_installation_id = sensitive(jsondecode(try(terracurl_request.github-runner-installation["main"].response, "{\"id\":\"\"}")).id)
}

resource "terracurl_request" "github-runner-api-token" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  name           = "github-runner-api-token"
  response_codes = ["200", "201"]
  url            = "https://${local.gh_endpoint}/app/installations/${local.gh_app_installation_id}/access_tokens"
  method         = "POST"

  headers = {
    Accept        = "application/json"
    Authorization = sensitive("Bearer ${local.gh_app_jwt_token}")
  }

  ignore_response_fields = [
    "permissions",
    "repository_selection",
    "token",
  ]
}

locals {
  gh_app_api_token = sensitive(jsondecode(try(terracurl_request.github-runner-api-token["main"].response, "{\"token\":\"\"}")).token)
}

resource "terracurl_request" "github-runner-registration-token" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  name           = "github-runner-registration-token"
  response_codes = ["200", "201"]
  url            = "https://${local.gh_endpoint}/orgs/${local.gh_owner}/actions/runners/registration-token"
  method         = "POST"

  headers = {
    Accept        = "application/json"
    Authorization = sensitive("Bearer ${local.gh_app_api_token}")
  }

  ignore_response_fields = [
    "token"
  ]
}

locals {
  gh_app_runner_token = sensitive(jsondecode(try(terracurl_request.github-runner-registration-token["main"].response, "{\"token\":\"<empty>\"}")).token)
}

resource "yandex_lockbox_secret_version" "github-runner-tokens" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  secret_id = yandex_lockbox_secret.github-runner["main"].id

  entries {
    key        = "GITHUB_APP_PRIVATE_KEY"
    text_value = local.gh_app_private_key
  }

  entries {
    key        = "GITHUB_APP_ID"
    text_value = local.gh_app_id
  }

  entries {
    key        = local.runner_lockbox_key
    text_value = local.gh_app_runner_token
  }

  lifecycle {
    replace_triggered_by = [
      terraform_data.github-runner-token,
    ]
  }
}

resource "yandex_iam_service_account" "github-runner" {
  for_each = toset(local.is_create_github_runner ? ["main"] : [])

  name = "${local.service}-gh-runner-sa"
}

# for get deploy token from metadata
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

resource "terraform_data" "github-runner-image" {
  input = {
    runner_os_image = local.runner_os_image
  }

  triggers_replace = [
    local.runner_os_image
  ]
}

resource "yandex_vpc_address" "github-runner" {
  for_each = local.runner_ssh_access ? { for id in local.runners_ids : id.key => id.ind } : {}

  name = "github-runner-${each.key}-ip"

  external_ipv4_address {
    zone_id = local.zones[each.value % length(local.zones)]
  }
}

resource "random_string" "github-runner-random-suffix" {
  for_each = toset(local.is_create_github_runner && local.runners_count > 0 ? ["main"] : [])

  length  = 3
  upper   = false
  special = false

  lifecycle {
    replace_triggered_by = [
      terraform_data.github-runner-config,
    ]
  }
}

locals {
  runner_suffix = try(random_string.github-runner-random-suffix["main"].result, "")
}

resource "yandex_compute_disk" "github-runner" {
  for_each = { for id in local.runners_ids : id.key => id.ind }

  name        = "github-runner-${each.key}-disk-${local.runner_suffix}"
  description = "runner config hash: ${local.runner_config_hash}"

  type     = "network-ssd"
  size     = 256
  zone     = local.zones[each.value % length(local.zones)]
  image_id = data.yandex_compute_image.this.id

  lifecycle {
    ignore_changes = [
      image_id
    ]
    replace_triggered_by = [
      terraform_data.github-runner-image,
      terraform_data.github-runner-config,
    ]
  }
}

resource "yandex_compute_instance" "github-runner" {
  for_each = { for id in local.runners_ids : id.key => id.ind }

  name        = "github-runner-${local.gh_label}-${each.key}-${local.runner_suffix}"
  description = "runner config hash: ${local.runner_config_hash}"

  platform_id = "standard-v3"
  zone        = local.zones[each.value % length(local.zones)]

  allow_stopping_for_update = true

  service_account_id = yandex_iam_service_account.github-runner["main"].id

  resources {
    cores  = 16
    memory = 32
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

    user-data = replace(local.runner_config, "#IND#", each.value)
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
    replace_triggered_by = [
      terraform_data.github-runner-config
    ]
    create_before_destroy = true
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
  yandex_apt_endpoint          = "mirror.yandex.ru"
  gh_pipelinse_endpoint        = "pipelines.actions.githubusercontent.com"
  gh_vstoken_endpoint          = "vstoken.actions.githubusercontent.com"

  common_endpoints = [
    local.ubuntu_apt_endpoint,
    local.ubuntu_apt_security_endpoint,
    local.yandex_apt_endpoint,
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
