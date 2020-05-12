resource "azurerm_resource_group" "permanent_infra_rg1" {
  name     = var.permanent_infra_rg_name
  location = var.permanent_infra_rg_location
}
output "permanent_infra_rg_name_out" {
  value = azurerm_resource_group.permanent_infra_rg1.name
}

resource "azurerm_storage_account" "remote_state_sa" {
  name                     = var.remote_state_sa_name
  resource_group_name      = azurerm_resource_group.permanent_infra_rg1.name
  location                 = azurerm_resource_group.permanent_infra_rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "permanent_infra"
  }
}

data "azurerm_key_vault_secret" "davids_home_ip" {
  name         = var.davids_home_ip_secret_name
  key_vault_id = azurerm_key_vault.kv1.id
}

data "azurerm_key_vault_secret" "shanikas_home_ip" {
  name         = var.shanikas_home_ip_secret_name
  key_vault_id = azurerm_key_vault.kv1.id
}

resource "azurerm_storage_account_network_rules" "sa_network_rules1" {
  resource_group_name  = azurerm_resource_group.permanent_infra_rg1.name
  storage_account_name = azurerm_storage_account.remote_state_sa.name

  default_action = "Deny"
  # tested with a private IP and it failed due to unpublished rules
  ip_rules = [
    data.azurerm_key_vault_secret.davids_home_ip.value,
    data.azurerm_key_vault_secret.shanikas_home_ip.value
  ]
  #  virtual_network_subnet_ids = [azurerm_subnet.test.id]
  bypass = ["Metrics"]
}

resource "azurerm_storage_container" "remote_state_sa_container1" {
  name                  = var.remote_state_sa_container1_name
  storage_account_name  = azurerm_storage_account.remote_state_sa.name
  container_access_type = "private"
}
