

module "acr" {
  source          = "./acr-module"
  project         = var.project
  creation_date   = var.creation_date
  expiration_date = var.expiration_date
  created_by      = var.created_by
  made_by         = var.made_by

  rg_location = "East US"
  sku         = "Basic"
}
module "cluster-module" {
  source          = "./cluster-module"
  project         = var.project
  creation_date   = var.creation_date
  expiration_date = var.expiration_date
  created_by      = var.created_by
  made_by         = var.made_by

  rg_location               = "East US"
  kubernetes_version        = "1.23.12"
  dns_prefix                = "example"
  default_node_pool_name    = "default"
  default_node_pool_nodes   = 3
  default_node_pool_vm_size = "Standard_B4ms"
  enable_auto_scaling       = true
  identity_type             = "SystemAssigned"
  argocd_version            = "5.16.1"
  argocd_values_file_path   = "/home/ron/Desktop/DevTube/devtube-infrastructure/terraform/cluster-module/helm-values/argo-values.yaml"
  cert_manager_version      = "1.10.1"
  external_secrets_version  = "0.6.1"
  ingress_nginx_version     = "4.4.0"
  acr_scope                 = module.acr.acr-scope

  react-api-key            = var.react-api-key
  react-app-id             = var.react-app-id
  react-auth-domain        = var.react-auth-domain
  react-messaging-senderId = var.react-messaging-senderId
  react-project-id         = var.react-project-id
  react-storage-bucket     = var.react-storage-bucket
  jwt-key                  = var.jwt-key
  root-user                = var.root-user
  root-password            = var.root-password
  my-ssh                   = var.my-ssh
  argo-password            = var.argo-password
}