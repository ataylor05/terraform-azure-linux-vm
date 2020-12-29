data "azurerm_virtual_network" "vm_vnet" {
  name                = var.target_vnet_name
  resource_group_name = var.target_vnet_resource_group
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.target_vnet_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name
  resource_group_name  = var.target_vnet_resource_group
}

resource "azurerm_public_ip" "vm_pip" {
  count               = var.enable_vm_public_ip == true ? 1 : 0
  name                = "${var.vm_name}-PIP"
  location            = var.region
  resource_group_name = var.vm_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment     = var.environment_tag
  }
}

resource "azurerm_network_interface" "pip_vm_nic" {
  count                     = var.enable_vm_public_ip == true ? 1 : 0
  name                      = "${var.vm_name}-NIC"
  location                  = var.region
  resource_group_name       = var.vm_rg_name

  ip_configuration {
    name                                    = "IpConfiguration1"
    subnet_id                               = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation           = "Dynamic"
    public_ip_address_id                    = azurerm_public_ip.vm_pip[count.index].id
  }
  tags = {
    environment     = var.environment_tag
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count                     = var.enable_vm_public_ip == false ? 1 : 0
  name                      = "${var.vm_name}-NIC"
  location                  = var.region
  resource_group_name       = var.vm_rg_name

  ip_configuration {
    name                                    = "IpConfiguration1"
    subnet_id                               = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation           = "Dynamic"
  }
  tags = {
    environment     = var.environment_tag
  }
}

resource "azurerm_availability_set" "vm_as" {
  name                = "${var.vm_name}-Availability-Set"
  location            = var.region
  resource_group_name = var.vm_rg_name
  managed = true

  tags = {
    environment     = var.environment_tag
  }
}

resource "azurerm_linux_virtual_machine" "vm_with_pip" {
  count                            = var.enable_vm_public_ip == true ? 1 : 0
  name                             = var.vm_name
  location                         = var.region
  resource_group_name              = var.vm_rg_name
  network_interface_ids            = [azurerm_network_interface.pip_vm_nic[count.index].id]
  size                          = var.vm_size
  availability_set_id              = azurerm_availability_set.vm_as.id
  disable_password_authentication  = false
  provision_vm_agent               = true
  admin_username                   = var.vm_username
  admin_password                   = var.vm_user_password
  computer_name                    = var.vm_hostname

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }
  os_disk {
    name                 = "${var.vm_name}-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = var.storage_type
    disk_size_gb         = var.os_disk_size
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_linux_virtual_machine" "vm_without_pip" {
  count                            = var.enable_vm_public_ip == false ? 1 : 0
  name                             = var.vm_name
  location                         = var.region
  resource_group_name              = var.vm_rg_name
  network_interface_ids            = [azurerm_network_interface.vm_nic[count.index].id]
  size                             = var.vm_size
  availability_set_id              = azurerm_availability_set.vm_as.id
  disable_password_authentication  = false
  provision_vm_agent               = true
  admin_username                   = var.vm_username
  admin_password                   = var.vm_user_password
  computer_name                    = var.vm_hostname

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }
  os_disk {
    name                 = "${var.vm_name}-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = var.storage_type
    disk_size_gb         = var.os_disk_size
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_managed_disk" "storage_disk" {
  name                 = "${var.vm_name}-Storage-Disk"
  location             = var.region
  resource_group_name  = var.vm_rg_name
  storage_account_type = var.storage_type
  create_option        = "Empty"
  disk_size_gb         = var.storage_disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "storage_disk_attachment_vm_with_pip" {
  count              = var.enable_vm_public_ip == true ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.storage_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_with_pip[count.index].id
  lun                = "1"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "storage_disk_attachment_vm_without_pip" {
  count              = var.enable_vm_public_ip == false ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.storage_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_without_pip[count.index].id
  lun                = "1"
  caching            = "ReadWrite"
}
