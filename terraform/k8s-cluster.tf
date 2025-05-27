resource "yandex_logging_group" "this" {
  name      = "${local.service}-k8s-logging-group"
  folder_id = local.folder_id
}

resource "yandex_kms_symmetric_key" "this" {
  name              = "${local.service}-k8s-kms-key"
  default_algorithm = "AES_256"
}

resource "yandex_iam_service_account" "this" {
  for_each = toset(["master", "node", "eso", "alb", "logging"])

  name = "${local.service}-k8s-sa-${each.key}"
}

resource "yandex_iam_service_account_key" "this" {
  for_each = toset(["eso", "alb", "logging"])

  service_account_id = yandex_iam_service_account.this[each.key].id
  key_algorithm      = "RSA_4096"
}

locals {
  roles = [
    { sa = "master", role = "k8s.clusters.agent" },
    { sa = "master", role = "k8s.tunnelClusters.agent" },
    { sa = "master", role = "vpc.publicAdmin" },
    { sa = "master", role = "load-balancer.admin" },
    { sa = "master", role = "logging.writer" },

    { sa = "node", role = "container-registry.images.puller" },

    { sa = "eso", role = "lockbox.payloadViewer" },
    { sa = "eso", role = "kms.keys.encrypterDecrypter" },

    { sa = "alb", role = "alb.editor" },
    { sa = "alb", role = "vpc.publicAdmin" },
    { sa = "alb", role = "certificate-manager.certificates.downloader" },
    { sa = "alb", role = "compute.viewer" },

    { sa = "logging", role = "logging.writer" },
    { sa = "logging", role = "monitoring.editor" },
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "this" {
  for_each = { for r in local.roles : "${r.sa}-${r.role}" => r }

  folder_id = local.folder_id
  role      = each.value.role
  member    = "serviceAccount:${yandex_iam_service_account.this[each.value.sa].id}"
}

resource "time_sleep" "this" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.this,
  ]

  create_duration = "10s"
}


locals {
  k8s_version = "1.29"
}

resource "yandex_kubernetes_cluster" "this" {
  depends_on = [
    time_sleep.this,
    yandex_mdb_postgresql_cluster.this,
  ]

  name       = "${local.service}-k8s-cluster"
  network_id = yandex_vpc_network.this.id

  release_channel = "STABLE"

  master {
    version   = local.k8s_version
    public_ip = local.k8s_use_external_ipv4

    security_group_ids = [yandex_vpc_security_group.this.id]

    maintenance_policy {
      auto_upgrade = false
    }

    master_logging {
      enabled = true

      log_group_id = yandex_logging_group.this.id

      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }

    dynamic "master_location" {
      for_each = toset(local.zones)

      content {
        zone      = master_location.key
        subnet_id = yandex_vpc_subnet.this[master_location.key].id
      }
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.this.id
  }

  service_account_id      = yandex_iam_service_account.this["master"].id
  node_service_account_id = yandex_iam_service_account.this["node"].id
}

resource "yandex_kubernetes_node_group" "this" {
  cluster_id = yandex_kubernetes_cluster.this.id
  name       = "${local.service}-k8s-node-group"

  version = local.k8s_version

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = false
      subnet_ids         = [for z in local.zones : yandex_vpc_subnet.this[z].id]
      security_group_ids = [yandex_vpc_security_group.this.id]
    }

    resources {
      cores         = 8
      memory        = 16
      core_fraction = 100
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  deploy_policy {
    max_expansion   = 3
    max_unavailable = 1
  }

  allocation_policy {
    dynamic "location" {
      for_each = local.zones

      content {
        zone = location.value
      }
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}

resource "kubernetes_namespace" "this" {
  depends_on = [
    yandex_kubernetes_cluster.this,
  ]

  metadata {
    name = local.service
  }
}

locals {
  k8s_cluster_id             = yandex_kubernetes_cluster.this.id
  k8s_cluster_endpoint       = local.k8s_use_external_ipv4 && !local.k8s_connect_by_internal_ipv4 ? yandex_kubernetes_cluster.this.master[0].external_v4_endpoint : yandex_kubernetes_cluster.this.master[0].internal_v4_endpoint
  k8s_cluster_ca_certificate = yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate
}
