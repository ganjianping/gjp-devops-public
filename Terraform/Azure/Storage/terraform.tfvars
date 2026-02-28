# Global/Provider Variables
subscription_id     = "" # Leave empty if you use 'az login' default
location            = "Southeast Asia"
environment         = "dev"
resource_group_name = "gjp-rg"

# Storage Configuration
storage_account_name     = "gjpstorage" # Letters and numbers only. A random suffix will be appended.
container_name           = "tf-container"
account_tier             = "Standard"
account_replication_type = "LRS" # LRS (Local), GRS (Geo), ZRS (Zone)

enable_versioning = false
public_access     = false

# Additional Tags
additional_tags = {
  Project = "GJPB"
  Owner   = "Gan Jianping"
}
