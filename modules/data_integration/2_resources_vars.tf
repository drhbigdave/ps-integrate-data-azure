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
variable "synapse_sql_server_count" {}
variable "synapse_sql_server_name" {}
variable "synapse_sa_sql_database_name" {}
variable "permanent_infra_key_vault_name" {} #needed?
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
# aci private subnet, no public ip
variable "container_subnet_name" {}
variable "vnet1_container_subnet_address_prefix2" {}
# aci volume sa, file share
variable "container_vol_sa1_name" {}
variable "container_vol_share_name" {}
variable "storage_share_quota" {}

variable "vnet1_nsg2_name" {}

variable "contgroup_network_profile_name" {}
variable "container_group1_name" {}
variable "ip_address_type" {}
variable "os_type" {}
variable "container_group1_count" {}
variable "container_name" {}
variable "container_image" {}
variable "container_vol_mnt_path" {}
variable "sql_sa_password_secret_name" {}
variable "sql_server_user_secret_name" {}
variable "sql_server_user_password_secret_name" {}
variable "aci_container_repo_tag" {}

variable "environment_name" {}
variable "data_factory_count" {}

#storage
variable "sensor_sa_name" {}
variable "container1_name" {}
variable "container2_name" {}
variable "container3_name" {}
variable "container4_name" {}
