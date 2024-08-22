terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
}

resource "azurerm_resource_group" "main" {
    name = "learn-tf-rg-australiaeast"
    location = "australiaeast"
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "learn-tf-vnet-australiaeast"

  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "main" {
  name                 = "learn-tf-subnet-australiaeast"

  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes     = ["10.0.0.0/24"]
}

# Create network interface card (NIC)
resource "azurerm_network_interface" "internal" {
  name                = "learn-tf-nic-int-australiaeast"
 
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "learn-tf-vm-australiaeast"

  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name

  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  admin_password        = "!ChangeMe1234"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.internal.id
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
