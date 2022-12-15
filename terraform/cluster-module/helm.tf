data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.devtube.name
  resource_group_name = azurerm_resource_group.devtube.name
}


provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)

  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  create_namespace = "true"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  values = [
    file(var.argocd_values_file_path)
  ]
}
# resource "helm_release" "ingress-nginx" {
#   name             = "ingress-nginx"
#   create_namespace = "true"
#   namespace        = "ingress-nginx"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   version          = var.ingress_nginx_version
# }
# resource "helm_release" "cert-manager" {
#   name             = "cert-manager"
#   create_namespace = "true"
#   namespace        = "cert-manager"
#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   version          = var.cert_manager_version
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }
# resource "helm_release" "external-secrets" {
#   name             = "external-secrets"
#   create_namespace = "true"
#   namespace        = "external-secrets"
#   repository       = "https://charts.external-secrets.io"
#   chart            = "external-secrets"
#   version          = var.external_secrets_version
# }
#  Warning: Helm release "argocd" was created but has a failed status. Use the `helm` command to investigate the error, correct it, then run Terraform again.
# │ 
# │   with module.cluster-module.helm_release.argocd,
# │   on cluster-module/helm.tf line 45, in resource "helm_release" "argocd":
# │   45: resource "helm_release" "argocd" {
# │ 
# ╵
# ╷
# │ Error: Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": no endpoints available for service "ingress-nginx-controller-admission"
# │ 
# │   with module.cluster-module.helm_release.argocd,
# │   on cluster-module/helm.tf line 45, in resource "helm_release" "argocd":
# │   45: resource "helm_release" "argocd" {
# │ 
# ╵