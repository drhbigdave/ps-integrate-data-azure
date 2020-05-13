data "azurerm_key_vault" "permanent_infra_kv1" {
  name                = var.permanent_infra_key_vault_name
  resource_group_name = var.permanent_infra_rg_name
}

data "azurerm_key_vault_secret" "davids_home_ip" {
  name         = var.davids_home_ip_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}

data "azurerm_key_vault_secret" "shanikas_home_ip" {
  name         = var.shanikas_home_ip_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}

data "azurerm_key_vault_secret" "sql_svradmin_login_name" {
  name         = var.sql_svradmin_login_name_secret
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}

data "azurerm_key_vault_secret" "sql_svradmin_login_password" {
  name         = var.sql_svradmin_login_password_secret
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}
data "azurerm_key_vault_secret" "dsvm_admin_password" {
  name         = var.dsvm_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}

data "azurerm_key_vault_secret" "sql_sa_password" {
  name         = var.sql_sa_password_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}
data "azurerm_key_vault_secret" "sql_server_user" {
  name         = var.sql_server_user_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}
data "azurerm_key_vault_secret" "sql_server_user_password" {
  name         = var.sql_server_user_password_secret_name
  key_vault_id = data.azurerm_key_vault.permanent_infra_kv1.id
}
