# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "terra_resource_group"
  location = "southcentralus"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "terra_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "terra_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "terra_nic"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Azure instance
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "terra_vm"
  computer_name         = "terrainstance"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = "southcentralus"
  size                  = "Standard_B1s"
  network_interface_ids  = [azurerm_network_interface.nic.id]
  admin_username        = "adminuser"
  disable_password_authentication = true

  admin_ssh_key {
    username = "adminuser"
    public_key = file("./id_rsa.pub")
  }

  os_disk {
    name              = "os_disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}