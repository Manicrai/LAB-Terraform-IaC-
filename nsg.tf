# NSG for Prod to block traffic from Dev
resource "azurerm_network_security_group" "nsg_prod" {
  name                = "nsg-spoke-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Deny_Inbound_From_Dev"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.2.0.0/16" # Dev address space
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_prod" {
  subnet_id                 = azurerm_subnet.spoke_prod_workload.id
  network_security_group_id = azurerm_network_security_group.nsg_prod.id
}

# NSG for Dev to block traffic from Prod
resource "azurerm_network_security_group" "nsg_dev" {
  name                = "nsg-spoke-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Deny_Inbound_From_Prod"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.1.0.0/16" # Prod address space
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_dev" {
  subnet_id                 = azurerm_subnet.spoke_dev_workload.id
  network_security_group_id = azurerm_network_security_group.nsg_dev.id
}
