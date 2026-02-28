variable "instance_name" {
  description = "Name tag for the Virtual Machine"
  type        = string
}

variable "instance_type" {
  description = "Azure VM Size"
  type        = string
  default     = "Standard_B2s"
}

variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "ubuntu"
}

variable "disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "vnet_name" {
  description = "Existing Virtual Network Name (leave empty to create new)"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Existing Subnet ID (leave empty to create new)"
  type        = string
  default     = ""
}

variable "enable_public_ip" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "open_tcp_ports" {
  description = "List of TCP ports to allow from anywhere (0.0.0.0/0)"
  type        = list(number)
  default     = []
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "use_spot_instance" {
  description = "Whether to use a Spot Instance instead of Pay-As-You-Go"
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "Maximum price for the Spot Instance in USD (use -1 to not specify max price)"
  type        = number
  default     = -1
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
