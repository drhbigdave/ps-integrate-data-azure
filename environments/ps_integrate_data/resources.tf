module "data_integration" {
  source = "../../modules/data_integration"
  #kv_uri                        = module.permanent_infra.key_vault_uri_out
  rg_vnet1_name                 = "vm_infra"
  rg_vnet1_location             = "East US"
  vnet1_name                    = "study_vm_infrastructure"
  vnet1_subnet_name             = "vm_subnet_dot2"
  vnet1_address_space           = ["10.0.0.0/16"]
  vnet1_subnet1_address_prefix1 = "10.0.2.0/24"
  infra_key_vault_name          = "drh-infra-keyvault1"
  permanent_infra_rg_name       = "permanent_infra"
  vnet1_nsg_name                = "home_access"
  davids_home_ip_secret_name    = "davids-home-ip"
  shanikas_home_ip_secret_name  = "shanikas-home-ip"
  # keep networking above for easy re-use for other VMs, VM below
  network_interface_name          = "dsvm01-nic0"
  dsvm_admin_password_secret_name = "dsvm-admin-password"
  dsvm_count                      = 1
  dsvm_vm1_name                   = "dsvm01"
  vm_size                         = "Standard_B4ms"   #Standard_DS3_v2
  vm_os_disk_sa_type              = "StandardSSD_LRS" #Standard_LRS, StandardSSD_LRS and Premium_LRS
  adminuser_name                  = "dsvmadmin0"
  #vm_publisher                    = "microsoft-dsvm"
  #vm_offer                        = "dsvm-win-2019"
  #vm_sku                          = "server-2019-g2"
  #vm_version                      = "latest"
  vm_publisher = "MicrosoftWindowsServer"
  vm_offer     = "WindowsServer"
  vm_sku       = "2019-datacenter-gensecond"
  vm_version   = "latest"

  container_subnet_name                  = "container_subnet_dot3"
  vnet1_container_subnet_address_prefix2 = "10.0.3.0/24"
  contgroup_network_profile_name         = "contgroup1"
  container_group1_name                  = "ac1-cg1"

  ip_address_type        = "Private"
  os_type                = "Linux"
  container_group1_count = 1
  container_name         = "drh-sql"
  container_image        = "exoplatform/sqlserver:2017-CU8"

  synapse_sql_server_name            = "databrickssql"
  synapse_sa_sql_database_name       = "databrickssqldb"
  sql_svradmin_login_name_secret     = "sql-svradmin-login-name"
  sql_svradmin_login_password_secret = "sql-svradmin-login-password"
  permanent_infra_key_vault_name     = "drh-infra-keyvault1"
}
/*
# use this information for data resources then delete
module "permanent_infra" {
  source                          = "../../../modules/permanent_infra"
  permanent_infra_rg_name         = "permanent_infra"
  permanent_infra_rg_location     = "East US"
  infra_kv1_name                  = "drh-infra-keyvault1"
  remote_state_sa_name            = "drhremotestate"
  remote_state_sa_container1_name = "tf-remote-state"
  davids_home_ip_secret_name      = "davids-home-ip"
  shanikas_home_ip_secret_name    = "shanikas-home-ip"
}
*/
