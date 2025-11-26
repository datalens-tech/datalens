# resource "helm_release" "alb_gateway_integration" {
#   name = "yc-alb-gateway-integration-controller"

#   chart = "gwin-chart"

#   version    = "v1.0.4"
#   repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/gwin"

#   namespace        = "alb-gateway-integration"
#   create_namespace = true
#   cleanup_on_fail  = true

#   values = [yamlencode({
#     folderId  = local.folder_id
#     clusterId = yandex_kubernetes_cluster.this.id
#     saKeySecretKey = jsonencode({
#       id                 = yandex_iam_service_account_key.this["alb"].id
#       service_account_id = yandex_iam_service_account.this["alb"].id
#       created_at         = yandex_iam_service_account_key.this["alb"].created_at
#       key_algorithm      = "RSA_4096"
#       public_key         = yandex_iam_service_account_key.this["alb"].public_key
#       private_key        = yandex_iam_service_account_key.this["alb"].private_key
#     })
#   })]

#   depends_on = [
#     yandex_kubernetes_cluster.this,
#   ]
# }
