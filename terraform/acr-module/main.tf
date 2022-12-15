resource "azurerm_resource_group" "devtube" {
  name     = "${var.project}-acr"
  location = var.rg_location

  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.project}"
  resource_group_name = azurerm_resource_group.devtube.name
  location            = azurerm_resource_group.devtube.location
  sku                 = var.sku
  admin_enabled       = false
  georeplications {
    location                = var.georeplications[0]
    zone_redundancy_enabled = true
    tags = {
      project         = var.project
      creation_date   = var.creation_date
      expiration_date = var.expiration_date
      created_by      = var.created_by
      made_by         = var.made_by
    }
  }
  georeplications {
    location                = var.georeplications[1]
    zone_redundancy_enabled = true
    tags = {
      project         = var.project
      creation_date   = var.creation_date
      expiration_date = var.expiration_date
      created_by      = var.created_by
      made_by         = var.made_by
    }
  }
  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}