
terraform {
  required_providers {
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.106.0" # 23.01.2024
    }
  }

  backend "s3" {
    bucket = var.BACKEND_STATE_BUCKET
    key    = var.BACKEND_STATE_KEY
    region = var.BACKEND_STATE_REGION

    skip_metadata_api_check     = true
    skip_credentials_validation = true
    skip_region_validation      = true
  }

  required_version = ">= 1.1.6"
}

provider "yandex" {
  token            = var.YC_TOKEN
  endpoint         = "${local.api_endpoint}:443"
  storage_endpoint = local.storage_endpoint
  cloud_id         = local.cloud_id
  folder_id        = local.folder_id
}

provider "kubernetes" {
  config_path = data.shell_script.kubeconfig.output["path"]
}

provider "helm" {
  kubernetes {
    config_path = data.shell_script.kubeconfig.output["path"]
  }

  registry {
    url      = "oci://${local.cr_endpoint}"
    username = "iam"
    password = var.YC_TOKEN
  }
}
