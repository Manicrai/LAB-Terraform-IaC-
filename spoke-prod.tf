resource "azurerm_virtual_network" "spoke_prod" {
  name                = "vnet-spoke-prod"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "spoke_prod_workload" {
  name                 = "snet-prod-workload"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_prod.name
  address_prefixes     = ["10.1.1.0/24"]
}
