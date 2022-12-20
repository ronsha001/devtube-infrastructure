module "acr" {
  source          = "./acr-module"
  project         = var.project
  creation_date   = var.creation_date
  expiration_date = var.expiration_date
  created_by      = var.created_by
  made_by         = var.made_by

  rg_location     = "East US"
  sku             = "Premium"
  georeplications = ["North Europe", "East Asia"]
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
}
# Replaced Jenkins VM with Github Actions
# module "vm-module" {
#   source          = "./vm-module"
#   project         = var.project
#   creation_date   = var.creation_date
#   expiration_date = var.expiration_date
#   created_by      = var.created_by
#   made_by         = var.made_by

#   rg_location                   = "East US"
#   address_space                 = ["10.0.0.0/16"]
#   address_prefixes              = ["10.0.2.0/24"]
#   public_ip_allocation_method   = "Static"
#   private_ip_address_allocation = "Dynamic"
#   vm_size                       = "Standard_B2s"
#   admin_username                = "adminuser"
#   custom_data                   = "/home/ron/Desktop/DevTube/devtube-infrastructure/terraform/vm-module/cloud-init-jenkins.txt"
#   admin_ssh_key_username        = "adminuser"
#   public_key_path               = "~/.ssh/id_rsa.pub"
#   os_disk_chaching              = "ReadWrite"
#   storage_account_type          = "Standard_LRS"
#   publisher                     = "Canonical"
#   offer                         = "UbuntuServer"
#   sku                           = "18.04-LTS"
#   image_version                 = "latest"
#   acr_scope                     = module.acr.acr-scope
# }