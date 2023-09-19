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

resource "azurerm_key_vault" "default" {
  name                        = "hub-${var.location}-kv"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false
  sku_name                    = "standard"
  enabled_for_deployment      = true
  tags                        = var.tags

  # access_policy {
  #   tenant_id      = data.azurerm_client_config.current.tenant_id
  #   object_id      = data.azuread_service_principal.spn.object_id
  #   application_id = data.azuread_service_principal.spn.application_id

  #   secret_permissions = [
  #     "Get", "List", "Set",
  #   ]
  # }
}

resource "azurerm_storage_account" "default" {
  name                     = "hubdefaultsa"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.tags
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "hub-${var.location}-la"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 91
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  name                       = "kv-diag"
  target_resource_id         = azurerm_key_vault.default.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }


  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}