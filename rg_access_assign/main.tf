data "azurerm_resource_group" "access_target" {
  name = "vm_infra"
}

data "azurerm_virtual_machine" "access_vm" {
  name                = "devm01"
  resource_group_name = data.azurerm_resource_group.access_target.name
}
resource "azurerm_user_assigned_identity" "example" {
  location            = data.azurerm_resource_group.access_target.location
  resource_group_name = data.azurerm_resource_group.access_target.name
  name                = "devm01-access"
}
## client repro
resource "azurerm_user_assigned_identity" "read" {
  location            = data.azurerm_resource_group.access_target.location
  resource_group_name = data.azurerm_resource_group.access_target.name
  name                = "rg-read-access"
}

resource "azurerm_user_assigned_identity" "write" {
  location            = data.azurerm_resource_group.access_target.location
  resource_group_name = data.azurerm_resource_group.access_target.name
  name                = "rg-write-access"
}

resource "azurerm_user_assigned_identity" "read_write" {
  location            = data.azurerm_resource_group.access_target.location
  resource_group_name = data.azurerm_resource_group.access_target.name
  name                = "rg-read-write-access"
}

resource "azurerm_role_assignment" "rg_read_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.read.principal_id
}

resource "azurerm_role_assignment" "rg_write_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.write.principal_id
}

resource "azurerm_role_assignment" "rg_read_write_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.read_write.principal_id
}

##
/*
resource "azurerm_role_assignment" "rg_read_access_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = "039b0876-7034-4ade-8598-d2c3f7f2eca7"
}

*/
resource "azurerm_role_assignment" "container1_access_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = "039b0876-7034-4ade-8598-d2c3f7f2eca7"
}
resource "azurerm_role_assignment" "user_ass_identity_access_assignment" {
  scope                = data.azurerm_resource_group.access_target.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}
/*
resource "azurerm_role_assignment" "vm_access_assignment" {
  scope                = data.azurerm_resource_group.access_vm.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_virtual_machine.identity.principal_id
}
*/

