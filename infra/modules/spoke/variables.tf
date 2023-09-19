variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location to deploy"
}

variable "vnet_address_space" {
  type        = list(any)
  description = "Virtual network address space"
}

variable "tags" {
  type        = map(any)
  description = "Tags to be used in every resource"
}

variable "default_subnet_address" {
  type        = list(string)
  description = "Default Subnet prefix"
}

variable "app_gw_subnet" {
  type        = list(string)
  description = "Application Gateway prefix"
}

variable "hub_rg_name" {
  type        = string
  description = "Hub resource group name to be used in vnet peering"
}

variable "hub_vnet_name" {
  type        = string
  description = "Hub vnet name to be used in vnet peering"
}

variable "hub_vnet_id" {
  type        = string
  description = "Hub vnet id to be used in vnet peering"
}