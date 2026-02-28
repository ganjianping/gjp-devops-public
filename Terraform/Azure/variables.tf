variable "subscription_id" {
  description = "Azure Subscription ID (Leave empty to use default from az login)"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure Region (e.g., Southeast Asia, East US)"
  type        = string
  default     = "Southeast Asia"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "gjp-rg"
}
