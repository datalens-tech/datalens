
terraform {
  required_providers {
    yandex = {
      source  = "registry.terraform.io/yandex-cloud/yandex"
      version = "0.142.0" # 22.05.2025
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0" # 26.02.2025
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0" # 20.12.2024
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
  host                   = local.k8s_cluster_endpoint
  cluster_ca_certificate = local.k8s_cluster_ca_certificate
  token                  = var.YC_TOKEN
}

provider "helm" {
  kubernetes {
    host                   = local.k8s_cluster_endpoint
    cluster_ca_certificate = local.k8s_cluster_ca_certificate
    token                  = var.YC_TOKEN
  }

  registry {
    url      = "oci://${local.cr_endpoint}"
    username = "iam"
    password = var.YC_TOKEN
  }
}
