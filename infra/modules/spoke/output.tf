output "rg_name" {
  value = azurerm_resource_group.this.name
}

output "rg_location" {
  value = azurerm_resource_group.this.location
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}