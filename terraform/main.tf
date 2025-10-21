terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    owner = var.owner
    environment = var.environment
  }
}