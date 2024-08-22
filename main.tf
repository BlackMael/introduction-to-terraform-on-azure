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
