data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv1" {
  name                        = var.infra_kv1_name
  location                    = azurerm_resource_group.permanent_infra_rg1.location
  resource_group_name         = azurerm_resource_group.permanent_infra_rg1.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false
  enabled_for_deployment = true
  enabled_for_template_deployment = true
/* maybe use this if you recreate the key vault someday
  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules = [
      data.azurerm_key_vault_secret.shanikas_home_ip.value, data.azurerm_key_vault_secret.davids_home_ip.value
    ]
  }
*/
  sku_name = "standard"
  #maybe these work below? they do not set the private endpoint setting, but
  # they do seem to add the IP; modding them does not modify anything, if they
  # ran they ran the first apply only
  provisioner "local-exec" {
    command = "az keyvault network-rule add --name drh-infra-keyvault1 --ip-address data.azurerm_key_vault_secret.davids_home_ip.value"
  }
  provisioner "local-exec" {
    command = "az keyvault network-rule add --name drh-infra-keyvault1 --ip-address data.azurerm_key_vault_secret.shanikas_home_ip.value"
  }

}
/* not sure how this got out of sync, maybe cuz I renamed the resource?
resource "azurerm_key_vault_access_policy" "kv1_access_policy" {
  key_vault_id = azurerm_key_vault.kv1.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  storage_permissions = [
    "get",
  ]
}

output "key_vault_uri_out" {
  value = azurerm_key_vault.kv1.vault_uri
}
output "key_vault_name_out" {
  value = azurerm_key_vault.kv1.name
}
*/
output "key_vault_id_out" {
  value = azurerm_key_vault.kv1.id
}
data "azurerm_key_vault_secret" "drh_object_id" {
  name         = "drh-object-id"
  key_vault_id = azurerm_key_vault.kv1.id
}
resource "azurerm_key_vault_access_policy" "drh" {
  key_vault_id = azurerm_key_vault.kv1.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_key_vault_secret.drh_object_id.value

  key_permissions = [
    "get",
    "list",
    "create",
    "import",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  certificate_permissions = [
    "get",
    "list",
    "update",
    "create",
    "import",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
  ]
}