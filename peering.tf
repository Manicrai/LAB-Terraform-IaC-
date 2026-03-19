# Peering Hub -> Prod
resource "azurerm_virtual_network_peering" "hub_to_prod" {
  name                      = "peer-hub-to-prod"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering Prod -> Hub
resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                      = "peer-prod-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_prod.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering Hub -> Dev
resource "azurerm_virtual_network_peering" "hub_to_dev" {
  name                      = "peer-hub-to-dev"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_dev.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering Dev -> Hub
resource "azurerm_virtual_network_peering" "dev_to_hub" {
  name                      = "peer-dev-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_dev.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
