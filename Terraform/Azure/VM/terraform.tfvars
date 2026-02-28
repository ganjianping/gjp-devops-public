# Global/Provider Variables
subscription_id     = "" # Leave empty to use 'az login' default
location            = "Southeast Asia"
environment         = "dev"
resource_group_name = "gjp-rg"

# Azure VM CPU-Only Server Configuration
# instance_name = "gjp-azure-cpu-only"
# instance_type = "Standard_B2s" # Standard_B2s (2C-4GB), Standard_D2s_v3 (2C-8GB)
# open_tcp_ports = [80, 443, 3306, 5432, 27017, 6379] # HTTP, HTTPS, MySQL, PostgreSQL, MongoDB, Redis

# Azure VM GPU Server Configuration (for LLMs)
instance_name = "gjp-azure-gpu"
# instance_type = "Standard_NC4as_T4_v3" # NVIDIA T4 (4C-28GB-1GPU) 
open_tcp_ports = [80, 443, 11434] # HTTP, HTTPS, LLM API
disk_size_gb   = 50

# Azure VM Common Configuration
vnet_name        = ""
subnet_id        = ""
os_type          = "ubuntu"
enable_public_ip = true
allowed_ssh_cidr = ["0.0.0.0/0"] # Change to your IP: ["YOUR_IP/32"]
ssh_user         = "ubuntu"
public_key_path  = "~/.ssh/id_rsa.pub"
disk_type        = "StandardSSD_LRS" # Standard_LRS, StandardSSD_LRS, Premium_LRS

# Spot Instance Configuration
use_spot_instance = false
# spot_max_price    = -1 # -1 means you won't be evicted for price reasons (only capacity)

# Additional Tags
additional_tags = {
  Project = "GJPB"
  Owner   = "Gan Jianping"
}
