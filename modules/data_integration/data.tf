data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "infra_kv" {
  name                = var.infra_key_vault_name
  resource_group_name = var.permanent_infra_rg_name
}

data "azurerm_user_assigned_identity" "read_write" {
  name = "rg-read-write-access"
  resource_group_name = azurerm_resource_group.vnet_infra.name

}