resource "azurerm_sql_server" "synapse_sql_server" {
  count                        = var.synapse_sql_server_count
  name                         = var.synapse_sql_server_name
  location                     = azurerm_resource_group.vnet_infra.location
  resource_group_name          = azurerm_resource_group.vnet_infra.name
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.sql_svradmin_login_name.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_svradmin_login_password.value

  tags = {
    environment = "pluralsight"
  }
}

resource "azurerm_sql_firewall_rule" "synapse_sql_server_fw_rule_drh" {
  count               = var.synapse_sql_server_count
  name                = "davids_home"
  resource_group_name = azurerm_resource_group.vnet_infra.name
  server_name         = azurerm_sql_server.synapse_sql_server[count.index].name
  start_ip_address    = data.azurerm_key_vault_secret.davids_home_ip.value
  end_ip_address      = data.azurerm_key_vault_secret.davids_home_ip.value
}
resource "azurerm_sql_firewall_rule" "synapse_sql_server_fw_rule_sd" {
  count               = var.synapse_sql_server_count
  name                = "Shanikas_home"
  resource_group_name = azurerm_resource_group.vnet_infra.name
  server_name         = azurerm_sql_server.synapse_sql_server[count.index].name
  start_ip_address    = data.azurerm_key_vault_secret.shanikas_home_ip.value
  end_ip_address      = data.azurerm_key_vault_secret.shanikas_home_ip.value
}
resource "azurerm_sql_firewall_rule" "synapse_sql_server_fw_rule_vnet" {
  count               = var.synapse_sql_server_count
  name                = "vnet_rule"
  resource_group_name = azurerm_resource_group.vnet_infra.name
  server_name         = azurerm_sql_server.synapse_sql_server[count.index].name
  start_ip_address    = "10.0.2.0"
  end_ip_address      = "10.0.3.255"
}
/*
resource "azurerm_storage_account" "synapse_sa" {
  name                     = var.synapse_sa_name
  resource_group_name      = azurerm_resource_group.synapse_rg.name
  location                 = azurerm_resource_group.synapse_rg.location
  account_tier             = "Standard"
  account_replication_type = var.synapse_sa_replication_type
}
*/
resource "azurerm_sql_database" "synapse_sa_sql_database" {
  count               = var.synapse_sql_server_count
  name                = var.synapse_sa_sql_database_name
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name
  server_name         = azurerm_sql_server.synapse_sql_server[count.index].name
  create_mode         = "Default"
  edition             = "Free"
  /*
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.synapse_sa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.synapse_sa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
*/


  tags = {
    environment = "pluralsight"
  }
}
