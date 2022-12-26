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
  name     = "${var.project}-acr"
  location = var.rg_location

  tags = merge(local.tags)
}

resource "azurerm_container_registry" "acr" {
  name                = var.project
  resource_group_name = azurerm_resource_group.devtube.name
  location            = azurerm_resource_group.devtube.location
  sku                 = var.sku
  admin_enabled       = true

  tags = merge(local.tags)
}