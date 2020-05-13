variable "rg_vnet1_name" {}
variable "rg_vnet1_location" {}
variable "vnet1_name" {}
variable "vnet1_address_space" {}
variable "vnet1_subnet_name" {}
variable "vnet1_subnet1_address_prefix1" {}
variable "vnet1_nsg_name" {}
variable "infra_key_vault_name" {}
#variable "kv_uri" {}
variable "permanent_infra_rg_name" {}
variable "davids_home_ip_secret_name" {}
variable "shanikas_home_ip_secret_name" {}

# synapse
variable "synapse_sql_server_name" {}
variable "synapse_sa_sql_database_name" {}
variable "permanent_infra_key_vault_name" {}
variable "sql_svradmin_login_name_secret" {}
variable "sql_svradmin_login_password_secret" {}
# dvsm
variable "network_interface_name" {}
variable "dsvm_admin_password_secret_name" {}
variable "dsvm_count" {}
variable "dsvm_vm1_name" {}
variable "vm_size" {}
variable "vm_os_disk_sa_type" {}
variable "adminuser_name" {}
variable "vm_publisher" {}
variable "vm_offer" {}
variable "vm_sku" {}
variable "vm_version" {}

# aci
variable "container_subnet_name" {}
variable "vnet1_container_subnet_address_prefix2" {}
variable "contgroup_network_profile_name" {}
variable "container_group1_name" {}
variable "ip_address_type" {}
variable "os_type" {}
variable "container_group1_count" {}
variable "container_name" {}
variable "container_image" {}
variable "sql_sa_password_secret_name" {}
variable "sql_server_user_secret_name" {}
variable "sql_server_user_password_secret_name" {}
