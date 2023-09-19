terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "3f88a6cf-48cf-493f-b263-704731daed8c"
    resource_group_name  = "drs-container-rg"
    storage_account_name = "drs_ghost_tfstate"
    container_name       = "tfstate"
    key                  = "terraform.state"
  }
}

provider "azurerm" {
  features {}
}