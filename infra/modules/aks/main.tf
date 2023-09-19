resource "azurerm_kubernetes_cluster" "ghost" {
  name                             = "ghost-aks-${var.environment}"
  location                         = var.location
  resource_group_name              = var.rg_name
  dns_prefix                       = "ghost-aks-${var.environment}"
  http_application_routing_enabled = true
  tags                             = var.tags

  default_node_pool {
    name       = "ghostdf"
    node_count = 1
    vm_size    = "standard_d2as_v5"
  }

  identity {
    type = "SystemAssigned"
  }
  ingress_application_gateway {
    subnet_id    = var.appgw_subnet_id
    gateway_name = "ghost-aks-ingress"
  }

  # Integration with Azure Monitor
  oms_agent {
    log_analytics_workspace_id = var.la_workspace_id
  }

  network_profile {
    network_plugin = "azure"
  }
}