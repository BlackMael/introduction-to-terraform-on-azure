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
