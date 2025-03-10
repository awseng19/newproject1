resource "azurerm_virtual_network" "maryam" {
  name                = "maryam-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mcit420zz5um.location
  resource_group_name = azurerm_resource_group.mcit420zz5um.name
}

resource "azurerm_subnet" "maryam" {
  name                 = "maryam1"
  resource_group_name  = azurerm_resource_group.mcit420zz5um.name
  virtual_network_name = azurerm_virtual_network.maryam.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "maryaminterface" {
  name                = "maryam-nic"
  location            = azurerm_resource_group.mcit420zz5um.location
  resource_group_name = azurerm_resource_group.mcit420zz5um.name

  ip_configuration {
    name                          = "maryam123"
    subnet_id                     = azurerm_subnet.maryam.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.mcit420zz5um.name
  location            = azurerm_resource_group.mcit420zz5um.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.maryaminterface.id,
  ]

  admin_password ="password1234$"

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

