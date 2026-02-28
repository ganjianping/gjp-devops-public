output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "public_ip" {
  description = "The public IP address of the Virtual Machine"
  value       = var.enable_public_ip ? azurerm_public_ip.pip[0].ip_address : ""
}

output "private_ip" {
  description = "The private IP address of the Virtual Machine"
  value       = azurerm_network_interface.nic.private_ip_address
}
