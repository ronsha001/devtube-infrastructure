locals {
  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_resource_group" "devtube" {
  name     = "${var.project}-cluster"
  location = var.rg_location

  tags = merge(local.tags)

}

resource "azurerm_kubernetes_cluster" "devtube" {
  name                = var.project
  location            = azurerm_resource_group.devtube.location
  resource_group_name = azurerm_resource_group.devtube.name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_nodes
    vm_size             = var.default_node_pool_vm_size
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.default_node_pool_min_count
    max_count           = var.default_node_pool_max_count
  }

  identity {
    type = var.identity_type
  }

  tags = merge(local.tags)

}

resource "azurerm_role_assignment" "cluster_pull_acr" {
  scope                = var.acr_scope
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.devtube.kubelet_identity[0].object_id
}

