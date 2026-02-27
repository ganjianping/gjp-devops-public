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

variable "image" {
  description = "Image to use for the boot disk"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Type of the boot disk"
  type        = string
  default     = "pd-standard"
}

variable "network" {
  description = "Network to attach the instance to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork to attach the instance to"
  type        = string
  default     = "default"
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
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
