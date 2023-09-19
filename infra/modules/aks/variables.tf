variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location to deploy"
}

variable "tags" {
  type        = map(any)
  description = "Tags to be used in every resource"
}

variable "appgw_subnet_id" {
  type        = string
  description = "Application gateway subnet id"
}

variable "la_workspace_id" {
  type        = string
  description = "Log analytics workspace id"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

