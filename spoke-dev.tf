resource "azurerm_virtual_network" "spoke_dev" {
  name                = "vnet-spoke-dev"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "spoke_dev_workload" {
  name                 = "snet-dev-workload"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_dev.name
  address_prefixes     = ["10.2.1.0/24"]
}
