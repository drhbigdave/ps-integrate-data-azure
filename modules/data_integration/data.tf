data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "infra_kv" {
  name                = var.infra_key_vault_name
  resource_group_name = var.permanent_infra_rg_name
}
