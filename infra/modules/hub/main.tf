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

  enabled_log {
    category = "AuditEvent"    

    retention_policy {
      enabled = false      
    }
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"    

    retention_policy {      
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