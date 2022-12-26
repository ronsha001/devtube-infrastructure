resource "azurerm_resource_group" "jenkins" {
  name     = "${var.project}-jenkins"
  location = var.rg_location

  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vNet"
  address_space       = var.address_space
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name

  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "jenkins" {
  name                = "${var.project}-jenkins-public-ip"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = azurerm_resource_group.jenkins.location
  allocation_method   = var.public_ip_allocation_method

  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_network_security_group" "jenkins" {
  name                = "${var.project}-sg"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  security_rule {
    name                       = "open-port-8080"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
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
  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_network_interface" "jenkins" {
  name                = "${var.project}-example-nic"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.jenkins.id
  }
  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}
resource "azurerm_network_interface_security_group_association" "jenkins" {
  network_interface_id      = azurerm_network_interface.jenkins.id
  network_security_group_id = azurerm_network_security_group.jenkins.id
}

resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "${var.project}-jenkins-ci"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = azurerm_resource_group.jenkins.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.jenkins.id,
  ]

  custom_data = filebase64(var.custom_data)

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.admin_ssh_key_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = var.os_disk_chaching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  tags = {
    project         = var.project
    creation_date   = var.creation_date
    expiration_date = var.expiration_date
    created_by      = var.created_by
    made_by         = var.made_by
  }
}

resource "azurerm_role_assignment" "vm_push_acr" {
  scope                = var.acr_scope
  role_definition_name = "AcrPush"
  principal_id         = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
}