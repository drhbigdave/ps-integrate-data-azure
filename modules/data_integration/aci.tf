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

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
