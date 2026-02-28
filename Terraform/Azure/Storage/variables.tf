variable "storage_account_name" {
  description = "Base name of the Storage Account (will append random suffix for uniqueness, letters and numbers only)"
  type        = string
}

variable "container_name" {
  description = "Name of the Storage Container (Bucket)"
  type        = string
  default     = "data"
}

variable "account_tier" {
  description = "Tier of the Storage Account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "enable_versioning" {
  description = "Enable versioning for blobs in the container"
  type        = bool
  default     = false
}

variable "public_access" {
  description = "Whether to allow public access to the container/blobs"
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
