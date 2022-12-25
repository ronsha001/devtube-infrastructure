data "azurerm_client_config" "current" {
  
}

data "external" "account_info" {
  program = [
    "az",
    "ad",
    "signed-in-user",
    "show",
    "--query",
    "{object_id:id}",
    "-o",
    "json",
  ]
}

resource "azurerm_key_vault" "devtube" {
  name                        = "${var.project}-secrets100"
  location                    = azurerm_resource_group.devtube.location
  resource_group_name         = azurerm_resource_group.devtube.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "SetSAS",
      "GetSAS",
      "DeleteSAS",
      "Update",
      "RegenerateKey"
    ]
  }

  tags = merge(local.tags)
}

resource "azurerm_key_vault_secret" "devtube_secret_1" {
  name         = var.react-api-key[0]
  value        = var.react-api-key[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_2" {
  name         = var.react-app-id[0]
  value        = var.react-app-id[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_3" {
  name         = var.react-auth-domain[0]
  value        = var.react-auth-domain[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_4" {
  name         = var.react-messaging-senderId[0]
  value        = var.react-messaging-senderId[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_5" {
  name         = var.react-project-id[0]
  value        = var.react-project-id[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_6" {
  name         = var.react-storage-bucket[0]
  value        = var.react-storage-bucket[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_7" {
  name         = var.jwt-key[0]
  value        = var.jwt-key[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_8" {
  name         = var.root-user[0]
  value        = var.root-user[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_9" {
  name         = var.root-password[0]
  value        = var.root-password[1]
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_10" {
  name         = "my-ssh"
  value        = var.my-ssh
  key_vault_id = azurerm_key_vault.devtube.id
}
resource "azurerm_key_vault_secret" "devtube_secret_11" {
  name         = var.argo-password[0]
  value        = var.argo-password[1]
  key_vault_id = azurerm_key_vault.devtube.id
}

resource "azurerm_key_vault_access_policy" "devtube-access" {
  key_vault_id = azurerm_key_vault.devtube.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.devtube.kubelet_identity[0].object_id

  key_permissions = var.key_permissions

  secret_permissions = var.secret_permissions
}