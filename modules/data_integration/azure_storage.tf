resource "azurerm_storage_account" "sensor_sa" {
  name                     = var.sensor_sa_name
  location                 = azurerm_resource_group.vnet_infra.location
  resource_group_name      = azurerm_resource_group.vnet_infra.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "ps_integrate_data"
  }
}
resource "azurerm_storage_account_network_rules" "test" {
  resource_group_name  = azurerm_resource_group.vnet_infra.name
  storage_account_name = azurerm_storage_account.sensor_sa.name

  default_action             = "Deny"
  ip_rules                   = [data.azurerm_key_vault_secret.davids_home_ip.value, data.azurerm_key_vault_secret.shanikas_home_ip.value]
  virtual_network_subnet_ids = [azurerm_subnet.container_subnet.id, azurerm_subnet.vnet1_subnet1.id]
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_container" "container1" {
  name                  = var.container1_name
  storage_account_name  = azurerm_storage_account.sensor_sa.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "container1_access_assignment" {
  #count = var.dsvm_count
  scope                = "ddddddd"
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = "sssssssssss"
}

resource "azurerm_storage_container" "container2" {
  name                  = var.container2_name
  storage_account_name  = azurerm_storage_account.sensor_sa.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "container3" {
  name                  = var.container3_name
  storage_account_name  = azurerm_storage_account.sensor_sa.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "container4" {
  name                  = var.container4_name
  storage_account_name  = azurerm_storage_account.sensor_sa.name
  container_access_type = "private"
}
