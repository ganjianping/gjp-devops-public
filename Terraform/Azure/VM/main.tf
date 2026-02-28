locals {
  image_config = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }
    debian = {
      publisher = "Debian"
      offer     = "debian-12"
      sku       = "12-gen2"
      version   = "latest"
    }
    centos = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_5-gen2"
      version   = "latest"
    }
    rhel = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "9-lvm-gen2"
      version   = "latest"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-vm-${var.environment}"
  location = var.location
  tags = merge({
    environment = var.environment
    managed_by  = "terraform"
  }, var.additional_tags)
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  count               = var.vnet_name == "" ? 1 : 0
  name                = "${var.instance_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = merge({ environment = var.environment }, var.additional_tags)
}

# Subnet
resource "azurerm_subnet" "subnet" {
  count                = var.subnet_id == "" ? 1 : 0
  name                 = "${var.instance_name}-${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name == "" ? azurerm_virtual_network.vnet[0].name : var.vnet_name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "pip" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "${var.instance_name}-${var.environment}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge({ environment = var.environment }, var.additional_tags)
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.instance_name}-${var.environment}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ssh_cidr
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = var.open_tcp_ports
    content {
      name                       = "Allow-TCP-${security_rule.value}"
      priority                   = 100 + index(var.open_tcp_ports, security_rule.value) + 1
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value)
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }
  }

  tags = merge({ environment = var.environment }, var.additional_tags)
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.instance_name}-${var.environment}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id == "" ? azurerm_subnet.subnet[0].id : var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.pip[0].id : null
  }
  tags = merge({ environment = var.environment }, var.additional_tags)
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.instance_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.instance_type
  admin_username      = var.ssh_user

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "${var.instance_name}-${var.environment}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = local.image_config[var.os_type].publisher
    offer     = local.image_config[var.os_type].offer
    sku       = local.image_config[var.os_type].sku
    version   = local.image_config[var.os_type].version
  }

  priority        = var.use_spot_instance ? "Spot" : "Regular"
  eviction_policy = var.use_spot_instance ? "Deallocate" : null
  max_bid_price   = var.use_spot_instance ? var.spot_max_price : -1

  tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.additional_tags
  )
}
