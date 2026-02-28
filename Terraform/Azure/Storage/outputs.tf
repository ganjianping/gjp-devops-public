output "storage_account_name" {
  description = "The name of the connected Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_container_name" {
  description = "The name of the Storage Container"
  value       = azurerm_storage_container.container.name
}

output "storage_primary_blob_endpoint" {
  description = "The primary blob endpoint of the Storage Account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}
