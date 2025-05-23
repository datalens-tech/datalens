# terraform provider
locals {
  api_endpoint     = var.API_ENDPOINT
  storage_endpoint = var.STORAGE_ENDPOINT
  cr_endpoint      = var.CR_ENDPOINT
}

# basic local
locals {
  service = "datalens-opensource"

  versions             = jsondecode(file("${path.module}/../versions-config.json"))
  ui_version           = local.versions["uiVersion"]
  us_version           = local.versions["usVersion"]
  auth_version         = local.versions["authVersion"]
  meta_manager_version = local.versions["metaManagerVersion"]
  backend_version      = local.versions["backendVersion"]

  profile   = var.PROFILE
  cloud_id  = var.CLOUD_ID
  folder_id = var.FOLDER_ID

  domain = var.DOMAIN

  # auto create wildcard domain certificate
  is_create_wildcard_certificate = true

  # auto create demo db with demo data and demo entries in us db
  is_create_demo_db   = true
  is_create_demo_data = false

  # auto create temporal service
  is_create_temporal_service = true

  # auto create dns zone in cloud
  is_create_dns_zone = false

  # auto create github runner
  is_create_github_runner = true

  # auto generate local kubeconfig file
  k8s_kubeconfig = false

  # next step k8s deploy applications
  k8s_cluster_ready = true

  # auto deploy prometheus stack
  k8s_monitoring = true

  # auto deploy external logging stack
  k8s_logging = true

  # install argo cd
  k8s_argo_cd = true

  # use local k8s ipv4 or external ipv4
  k8s_allow_from_public_net    = true
  k8s_use_external_ipv4        = true
  k8s_connect_by_internal_ipv4 = false
}

