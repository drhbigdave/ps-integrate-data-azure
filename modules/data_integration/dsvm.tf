resource "azurerm_public_ip" "dvsm_public_ip" {
  count                   = var.dsvm_count
  name                    = "dsvm_public_ip"
  location                = azurerm_resource_group.vnet_infra.location
  resource_group_name     = azurerm_resource_group.vnet_infra.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "dvsm"
  }
}

resource "azurerm_network_interface" "dsvm_int" {
  count               = var.dsvm_count
  name                = var.network_interface_name
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet1_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dvsm_public_ip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "dsvm_assoc" {
  network_interface_id      = azurerm_network_interface.dsvm_int[0].id
  network_security_group_id = azurerm_network_security_group.vnet1_nsg.id
}

data "azurerm_key_vault_secret" "dsvm_admin_password" {
  name         = var.dsvm_admin_password_secret_name
  key_vault_id = var.kv_id
}

resource "azurerm_windows_virtual_machine" "dsvm_vm1" {
  count               = var.dsvm_count
  name                = var.dsvm_vm1_name
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name
  size                = var.vm_size
  admin_username      = var.adminuser_name
  admin_password      = data.azurerm_key_vault_secret.dsvm_admin_password.value
  network_interface_ids = [
    azurerm_network_interface.dsvm_int[count.index].id,
  ]
  timeouts {
    create = "45m"
    delete = "30m"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_sa_type #Standard_LRS, StandardSSD_LRS and Premium_LRS
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }
}
