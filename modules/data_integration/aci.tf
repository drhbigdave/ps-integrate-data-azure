resource "azurerm_subnet" "container_subnet" {
  name                 = var.container_subnet_name
  resource_group_name  = azurerm_resource_group.vnet_infra.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefix       = var.vnet1_container_subnet_address_prefix2

  delegation {
    name = "contgroupdelegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_network_profile" "contgroup_network_profile" {
  name                = var.contgroup_network_profile_name
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name

  container_network_interface {
    name = "contgroupnic"

    ip_configuration {
      name      = "ipconfig"
      subnet_id = azurerm_subnet.container_subnet.id
    }
  }
}

resource "azurerm_storage_account" "container_vol_sa1" {
  name                     = var.container_vol_sa1_name
  resource_group_name      = azurerm_resource_group.vnet_infra.name
  location                 = azurerm_resource_group.vnet_infra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules = [data.azurerm_key_vault_secret.shanikas_home_ip.value,
    data.azurerm_key_vault_secret.davids_home_ip.value]
    virtual_network_subnet_ids = [azurerm_subnet.vnet1_subnet1.id]
  }
}
resource "azurerm_storage_share" "container_vol_sa1_share1" {
  name                 = var.container_vol_share_name
  storage_account_name = azurerm_storage_account.container_vol_sa1.name
  quota                = var.storage_share_quota
}
resource "azurerm_container_group" "container_group1" {
  count               = var.container_group1_count
  name                = var.container_group1_name
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name
  ip_address_type     = var.ip_address_type
  network_profile_id  = azurerm_network_profile.contgroup_network_profile.id
  #  dns_name_label      = var.dns_name_label
  os_type = var.os_type

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = "0.5"
    memory = "1.5"
    volume {
      name                 = azurerm_storage_share.container_vol_sa1_share1.name
      mount_path           = var.container_vol_mnt_path
      storage_account_name = azurerm_storage_account.container_vol_sa1.name
      storage_account_key  = azurerm_storage_account.container_vol_sa1.secondary_access_key
      share_name           = azurerm_storage_share.container_vol_sa1_share1.name
    }
    environment_variables = {
      SQLSERVER_DATABASE = "Pollution",
    }
    secure_environment_variables = {
      SA_PASSWORD        = data.azurerm_key_vault_secret.sql_sa_password.value,
      SQLSERVER_USER     = data.azurerm_key_vault_secret.sql_server_user.value,
      SQLSERVER_PASSWORD = data.azurerm_key_vault_secret.sql_server_user_password.value,
    }

    ports {
      port     = 1433
      protocol = "TCP"
    }
  }

  tags = {
    environment    = "testing"
    container_repo = var.aci_container_repo_tag
  }
}
