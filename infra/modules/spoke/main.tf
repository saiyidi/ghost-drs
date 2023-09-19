resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${azurerm_resource_group.this.name}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "default" {
  name                 = "${azurerm_resource_group.this.name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.default_subnet_address
}

resource "azurerm_subnet" "appgw" {
  name                 = "appgw"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.app_gw_subnet
}

resource "azurerm_network_security_group" "default" {
  name                = "${azurerm_resource_group.this.name}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

# resource "azurerm_route_table" "default" {
#   name                = "${azurerm_resource_group.this.name}-udr"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   tags                = var.tags

#   #   route {
#   #     name                   = "${var.environment}-subnet-to-firewall"
#   #     address_prefix         = "0.0.0.0/0"
#   #     next_hop_type          = "VirtualAppliance"
#   #     next_hop_in_ip_address = var.route_table_next_hop_ip
#   #   }
# }

# resource "azurerm_subnet_route_table_association" "default" {
#   subnet_id      = azurerm_subnet.default.id
#   route_table_id = azurerm_route_table.default.id
# }

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "hub-to-${azurerm_resource_group.this.name}-peering"
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_gateway_transit        = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "${azurerm_resource_group.this.name}-to-hub-peering"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_gateway_transit        = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
