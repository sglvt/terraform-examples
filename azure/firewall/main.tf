data "azurerm_resource_group" "rm" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "example" {
  name                = var.stack_name
  resource_group_name = data.azurerm_resource_group.rm.name
}

data "azurerm_subnet" "example_a" {
  name                 = "${var.stack_name}-a"
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.rm.name
}

resource "azurerm_firewall" "fw1" {
  name                = "fw1"
  location            = data.azurerm_resource_group.rm.location
  resource_group_name = data.azurerm_resource_group.rm.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
}