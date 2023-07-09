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

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "azure-rg"
  location = "southcentralus"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "azure-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "azure-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "azure-nic"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "azure-nsg"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate network security group with subnet
resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Azure VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "azure-vm"
  computer_name         = "azureinstance"
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
