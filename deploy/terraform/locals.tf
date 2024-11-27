# terraform provider
locals {
  api_endpoint     = var.API_ENDPOINT
  storage_endpoint = var.STORAGE_ENDPOINT
  cr_endpoint      = var.CR_ENDPOINT
}

# basic local
locals {
  service = "datalens-opensource-sandbox"

  versions            = jsondecode(file("${path.module}/../../versions-config.json"))
  ui_version          = local.versions["uiVersion"]
  us_version          = local.versions["usVersion"]
  data_api_version    = local.versions["dataApiVersion"]
  control_api_version = local.versions["controlApiVersion"]
  zitadel_version     = "2.54.9"

  profile   = var.PROFILE
  cloud_id  = var.CLOUD_ID
  folder_id = var.FOLDER_ID

  domain = var.DOMAIN

  # auto create demo data in demo db with demo crypto key for connection
  is_create_demo_db    = true
  is_install_demo_data = true

  # may be disabled after resave demo connection with real db connection
  is_add_demo_crypto_key = false

  # auto create dns zone in cloud
  is_create_dns_zone = false

  # create zitadel db, app and ingress
  is_zitadel_enabled = true

  # may be disabled after first zitadel init
  is_zitadel_need_init_job_run = false

  # auto create github runner
  is_create_github_runner = true

  # auto deploy prometheus stack
  k8s_monitoring = true

  # use local k8s ipv4 by security reason
  k8s_allow_from_public_net    = true
  k8s_use_external_ipv4        = true
  k8s_connect_by_internal_ipv4 = false
}

