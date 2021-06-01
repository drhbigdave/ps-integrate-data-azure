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
  vms                             = ["dsvm02"]
  vm_values = {
    dsvm02 = {
      name                    = "dsvm02"
      size                    = "Standard_B4ms"
      admin_username          = "dsvmadmin0"
      os_storage_account_type = "StandardSSD_LRS"
      identity_type           = "UserAssigned"
      image_publisher         = "microsoft-dsvm"
      image_offer             = "dsvm-win-2019"
      image_sku               = "server-2019-g2"
      image_version           = "latest"
    }
  }

  #ACI
  container_subnet_name                  = "container_subnet_dot3"
  vnet1_container_subnet_address_prefix2 = "10.0.3.0/24"
  vnet1_nsg2_name                        = "SQLonly"
  contgroup_network_profile_name         = "pscontgroup1"
  container_group1_name                  = "ac1-cg1-ps"

  container_vol_sa1_name   = "drhcontsa1"
  container_vol_share_name = "sqlvol"
  storage_share_quota      = 2

  sql_sa_password_secret_name          = "sql-sa-password"
  sql_server_user_secret_name          = "sql-server-user"
  sql_server_user_password_secret_name = "sql-server-user-password"
  aci_container_repo_tag               = "https://hub.docker.com/r/exoplatform/sqlserver/" #"https://hub.docker.com/_/microsoft-mssql-server"

  ip_address_type        = "Private"
  os_type                = "Linux"
  container_group1_count = 1
  container_name         = "drh-sql"
  container_image        = "mcr.microsoft.com/mssql/server:2017-latest" #"exoplatform/sqlserver:2017-CU8"
  container_vol_mnt_path = "/var/opt/mssql"

  synapse_sql_server_count           = 1
  synapse_sql_server_name            = "drhpssql"
  synapse_sa_sql_database_name       = "drhpssqldb"
  sql_svradmin_login_name_secret     = "sql-svradmin-login-name"
  sql_svradmin_login_password_secret = "sql-svradmin-login-password"
  permanent_infra_key_vault_name     = "drh-infra-keyvault1"

  environment_name   = "dev"
  data_factory_count = 1

  sensor_sa_name  = "drhsensordata"
  container1_name = "sensor-sink-aws"
  container2_name = "sensor-sink-raw"
  container3_name = "sensor-sink-realtime"
  container4_name = "sensor-sink-stage"
  #dsvm_sys_assigned_identity = module.data_integratiom.dsvm_sys_assigned_identity

  instances             = ["vm-instance1", "vm-instance2", "vm-instance3"]
  nb_disks_per_instance = 2
  tags = {
    environment = "test"
  }

  # old vm values
  dsvm_count         = 1
  dsvm_vm1_name      = "dsvm01"
  vm_size            = "Standard_D2s_v3" #Standard_DS3_v2
  vm_os_disk_sa_type = "StandardSSD_LRS" #Standard_LRS, StandardSSD_LRS and Premium_LRS
  adminuser_name     = "dsvmadmin0"
  vm_publisher       = "microsoft-dsvm"
  vm_offer           = "dsvm-win-2019"
  vm_sku             = "server-2019"
  vm_version         = "latest"


  /*
  app_service_plan_name = "drh-appsvc-plan1"
  app_service_plan_sku_tier = "Standard"
  app_service_plan_sku_size = "S1"
  app_service_function_name = "drh-appsvc-plan1-func1"
  functions_storage_account_name = ""
  
  functions_storage_account_primary_access_key
  consumption_plan_name
  consumption_plan_kind
  consumption_plan_sku_tier
  consumption_plan_sku_size
  consumption_function_name
  consumption_linux_plan
  consumption_linux_plan_kind
  consumption_linux_plan_sku_tier
  consumption_linux_plan_sku_size
  consumption_linux_function_name
  consumption_linux_function_os_type
*/
}


/*
## scratch stuff
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
  dsvm_vm1_name      = "dsvm01"
  vm_size            = "Standard_B4ms"   #Standard_DS3_v2
  vm_os_disk_sa_type = "StandardSSD_LRS" #Standard_LRS, StandardSSD_LRS and Premium_LRS
  adminuser_name     = "dsvmadmin0"
  vm_publisher = "MicrosoftWindowsServer"
  vm_offer     = "WindowsServer"
  vm_sku       = "2019-datacenter-gensecond"
  vm_version   = "latest"
  #vm_publisher                    = "microsoft-dsvm"
  #vm_offer                        = "dsvm-win-2019"
  #vm_sku                          = "server-2019-g2"
  #vm_version                      = "latest"
        #image_publisher         = "MicrosoftWindowsServer"
      #image_offer             = "WindowsServer"
      #image_sku               = "2019-datacenter-gensecond"
      #image_version           = "latest"
*/
