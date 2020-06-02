resource "azurerm_data_factory" "data_factory1" {
  count               = var.data_factory_count
  name                = "${var.environment_name}pipelinedf"
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name
  identity {
    type = "SystemAssigned"
  }

  tags = {
    course      = "pluralsight integrating data in azure"
    environment = var.environment_name
  }
}
/*
resource "azurerm_storage_account" "df_sa1" {
  name                     = "${var.environment_name}pipelinesa1"
  location                 = azurerm_resource_group.df_rg.location
  resource_group_name      = azurerm_resource_group.df_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    course      = "pluralsight data pipelines in azure"
    environment = var.environment_name
  }
}

resource "azurerm_storage_container" "df_sa1_cont1" {
  name                  = "sink"
  storage_account_name  = azurerm_storage_account.df_sa1.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "df_sa1_cont2" {
  name                  = "staging"
  storage_account_name  = azurerm_storage_account.df_sa1.name
  container_access_type = "private"
}


resource "azurerm_key_vault" "df_kv1" {
  depends_on                  = [data.azurerm_key_vault.infra_kv]
  name                        = "${var.environment_name}dfkv"
  location                    = azurerm_resource_group.df_rg.location
  resource_group_name         = azurerm_resource_group.df_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"
  #maybe these work below? they do not set the private endpoint setting, but
  # they do seem to add the IP; modding them does not modify anything, if they
  # ran they ran the first apply only
  /*
  provisioner "local-exec" {
    command = "az keyvault network-rule add --name azurerm_key_vault.df_kv1.name  --ip-address data.azurerm_key_vault_secret.davids_home_ip.value"
  }
  provisioner "local-exec" {
    #command = "az keyvault network-rule add --name azurerm_key_vault.df_kv1.name --ip-address data.azurerm_key_vault_secret.shanikas_home_ip.value"
  }

}

resource "null_resource" "kv_network_rule1" {
  provisioner "local-exec" {
    command = "az keyvault network-rule add --name azurerm_key_vault.df_kv1.name --ip-address data.azurerm_key_vault_secret.davids_home_ip.value"
  }
  depends_on = [azurerm_key_vault.df_kv1]
}

resource "null_resource" "kv_network_rule2" {
  depends_on = [
    azurerm_key_vault.df_kv1
  ]
  provisioner "local-exec" {
    command = "az keyvault network-rule add --name azurerm_key_vault.df_kv1.name --ip-address data.azurerm_key_vault_secret.shanikas_home_ip.value"
  }
}


resource "azurerm_key_vault_access_policy" "df_kv1_access_policy" {
  key_vault_id = azurerm_key_vault.df_kv1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]

  storage_permissions = [
    "get",
  ]
}

resource "azurerm_key_vault_access_policy" "df_kv1_access_policy2" {
  key_vault_id = azurerm_key_vault.df_kv1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_data_factory.data_factory1.identity.0.principal_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]

  storage_permissions = [
    "get",
  ]
}

output "davids_ip_out" {
  value = data.azurerm_key_vault_secret.davids_home_ip.value
}
*/
