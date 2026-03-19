# ==========================================
# MÁQUINA DE PRODUCCIÓN (Spoke Prod)
# ==========================================
# Tarjeta de red sin IP Pública
resource "azurerm_network_interface" "spoke_prod_nic" {
  name                = "nic-vm-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke_prod_workload.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM en Producción
resource "azurerm_linux_virtual_machine" "vm_spoke_prod" {
  name                            = "vm-spoke-prod"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.spoke_prod_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ==========================================
# MÁQUINA DE DESARROLLO (Spoke Dev)
# ==========================================
# Tarjeta de red sin IP Pública
resource "azurerm_network_interface" "spoke_dev_nic" {
  name                = "nic-vm-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke_dev_workload.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM en Desarrollo
resource "azurerm_linux_virtual_machine" "vm_spoke_dev" {
  name                            = "vm-spoke-dev"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.spoke_dev_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Salidas para conocer las IPs Privadas exactas al terminar
output "ip_privada_produccion" {
  value       = azurerm_network_interface.spoke_prod_nic.private_ip_address
  description = "Dirección IP Privada de la VM en el entorno de Producción"
}

output "ip_privada_desarrollo" {
  value       = azurerm_network_interface.spoke_dev_nic.private_ip_address
  description = "Dirección IP Privada de la VM en el entorno de Desarrollo"
}
