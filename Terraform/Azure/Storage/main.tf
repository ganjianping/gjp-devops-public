resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-storage-${var.environment}"
  location = var.location
  tags = merge({
    environment = var.environment
    managed_by  = "terraform"
  }, var.additional_tags)
}

# Generate a random suffix for storage account name uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${lower(var.storage_account_name)}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  
  # Public access allowance on the account level
  allow_nested_items_to_be_public = var.public_access

  blob_properties {
    versioning_enabled = var.enable_versioning
  }

  tags = merge({
    environment = var.environment
    managed_by  = "terraform"
  }, var.additional_tags)
}

# Storage Container (like an S3 bucket)
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.public_access ? "blob" : "private"
}
