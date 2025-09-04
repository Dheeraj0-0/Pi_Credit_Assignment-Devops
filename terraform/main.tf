
# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Create a central resource group for the project
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Networking Module
module "vpc" {
  source              = "./modules/vpc"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Security Module
module "security" {
  source              = "./modules/security"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_subnet_id       = module.vpc.app_subnet_id
  db_subnet_id        = module.vpc.db_subnet_id
}

# Application Infrastructure Module
module "app" {
  source                = "./modules/app"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  db_admin_login        = var.db_admin_login
  db_password           = var.db_password
  app_subnet_id         = module.vpc.app_subnet_id
  db_subnet_id          = module.vpc.db_subnet_id
  db_security_group_id  = module.security.db_nsg_id
}
