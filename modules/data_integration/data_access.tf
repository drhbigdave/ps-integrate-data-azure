
/*
# is applied to rg but don't want to change the name yet
resource "azurerm_role_assignment" "container1_access_assignment" {
  for_each = toset(var.vms)
  scope                = azurerm_resource_group.vnet_infra.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_windows_virtual_machine.vm[each.key].identity[0].principal_id #works
}


resource "azurerm_user_assigned_identity" "example" {
  location                 = azurerm_resource_group.vnet_infra.location
  resource_group_name      = azurerm_resource_group.vnet_infra.name
  name = "devm01-access"
}

output "vm_access_managed_identity" {
    value = azurerm_user_assigned_identity.example.principal_id
}
*/
