# Dirección IP Pública para el Jumpbox
resource "azurerm_public_ip" "jumpbox_pip" {
  name                = "pip-jumpbox"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Security Group para el Jumpbox (Permitir SSH)
resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "nsg-jumpbox"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # En producción, restringir a tu IP pública real
    destination_address_prefix = "*"
  }
}

# Tarjeta de Red (NIC) para el Jumpbox en la red Shared Services del Hub
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "nic-jumpbox"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hub_shared_services.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_pip.id
  }
}

# Asociación del NSG con la Tarjeta de red
resource "azurerm_network_interface_security_group_association" "jumpbox_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.jumpbox_nic.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

# Máquina Virtual pequeña (Linux Ubuntu)
resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                            = "vm-jumpbox"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s" # Tamaño pequeño y económico
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!" # Sólo para el lab, usar SSH o KeyVault en prod
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id,
  ]

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

# Salida para conocer la IP Pública conectarse
output "jumpbox_public_ip" {
  value       = azurerm_public_ip.jumpbox_pip.ip_address
  description = "La dirección IP pública del Jumpbox para conectarse por SSH."
}
