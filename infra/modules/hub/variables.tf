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

variable "default_subnet_address" {
  type        = list(any)
  description = "Default Subnet prefix"
}

variable "tags" {
  type        = map(any)
  description = "Tags to be used in every resource"
}