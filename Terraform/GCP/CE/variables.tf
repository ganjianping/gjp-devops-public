variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
  default     = "asia-southeast1"
}

variable "gcp_zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-southeast1-a"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-medium"
}

variable "os_type" {
  description = "Operating system type for the instance"
  type        = string
  default     = "ubuntu"
}

variable "image" {
  description = "Image to use for the boot disk (leave empty to use os_type)"
  type        = string
  default     = ""
}

variable "disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the boot disk"
  type        = string
  default     = "pd-balanced"
}

variable "network" {
  description = "Network to attach the instance to"
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "Subnetwork to attach the instance to"
  type        = string
  default     = ""
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP to the instance"
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

variable "tags" {
  description = "Network tags for the instance"
  type        = list(string)
  default     = []
}

variable "use_spot_instance" {
  description = "Whether to use a Spot (Preemptible) Instance instead of On-Demand"
  type        = bool
  default     = false
}

variable "additional_labels" {
  description = "Additional labels to apply to resources"
  type        = map(string)
  default     = {}
}
