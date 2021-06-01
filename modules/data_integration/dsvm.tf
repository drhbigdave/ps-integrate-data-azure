locals {
  vm_datadiskdisk_count_map = { for k in toset(var.instances) : k => var.nb_disks_per_instance }
  luns                      = { for k in local.datadisk_lun_map : k.datadisk_name => k.lun }
  datadisk_lun_map = flatten([
    for vm_name, count in local.vm_datadiskdisk_count_map : [
      for i in range(count) : {
        datadisk_name = format("datadisk_%s_disk%02d", vm_name, i)
        lun           = i
      }
    ]
  ])
}

data "azurerm_user_assigned_identity" "data_rg_access" {
  name                = "devm01-access"
  resource_group_name = azurerm_resource_group.vnet_infra.name
}

output "user_assigned_id_principal_id" {
  value = data.azurerm_user_assigned_identity.data_rg_access.principal_id
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                    = "vm_public_ip"
  location                = azurerm_resource_group.vnet_infra.location
  resource_group_name     = azurerm_resource_group.vnet_infra.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "dvsm"
  }
}

resource "azurerm_network_interface" "vm_int" {
  name                = "${var.network_interface_name}-de01"
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet1_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm_assoc" {
  network_interface_id      = azurerm_network_interface.vm_int.id
  network_security_group_id = azurerm_network_security_group.vnet1_nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  location            = azurerm_resource_group.vnet_infra.location
  resource_group_name = azurerm_resource_group.vnet_infra.name
  for_each            = toset(var.vms)
  name                = var.vm_values[each.value].name
  size                = var.vm_values[each.value].size
  admin_username      = var.vm_values[each.value].admin_username
  admin_password      = data.azurerm_key_vault_secret.dsvm_admin_password.value
  network_interface_ids = [
    azurerm_network_interface.vm_int.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_values[each.value].os_storage_account_type #Standard_LRS, StandardSSD_LRS and Premium_LRS
  }

  source_image_reference {
    publisher = var.vm_values[each.value].image_publisher
    offer     = var.vm_values[each.value].image_offer
    sku       = var.vm_values[each.value].image_sku
    version   = var.vm_values[each.value].image_version
  }

  identity {
    #type = var.vm_values[each.value].identity_type
    type = "UserAssigned"
    #identity_ids = output.user_assigned_id_principal_id #output not declared error
    #identity_ids = data.azurerm_user_assigned_identity.data_rg_access.principal_id #invalid value for "v" parameter 
    identity_ids = [
      data.azurerm_user_assigned_identity.data_rg_access.id,
    ]
  }
}
/*
output "principal_id" {
  value = azurerm_windows_virtual_machine.vm["devm01"].identity[0].principal_id
  #value = [for attribute in azurerm_windows_virtual_machine.dsvm_vm1[each.key].identity : attribute.principal_id]
  #value = [for attribute in azurerm_windows_virtual_machine.dsvm_vm1 : attribute.identity["principal_id"]]
  #value = {for k, v in azurerm_windows_virtual_machine.dsvm_vm1[0].identity : k => v.tenant_id}
  #value = [for attribute in azurerm_windows_virtual_machine.dsvm_vm1[each.key].identity : attribute[each.key].principal_id]
  #value = { for k, v in azurerm_windows_virtual_machine.vm : k => v.identity[0].principal_id}
  #value = [ for vm in azurerm_windows_virtual_machine.dsvm_vm1 : for v in vm.identity => v.principal_id ]
}

*/
