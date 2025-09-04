
resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowWebInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowPostgresInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.1.0/24" # Only from App Subnet
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
