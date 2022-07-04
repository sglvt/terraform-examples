data "azurerm_resource_group" "rm" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "example" {
  name                = var.stack_name
  resource_group_name = data.azurerm_resource_group.rm.name
  location            = data.azurerm_resource_group.rm.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "${var.stack_name}-snet1"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.rm.name
  address_prefixes     = ["10.0.0.0/20"]
}
