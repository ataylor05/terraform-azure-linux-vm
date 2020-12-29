# terraform-azure-linux-vm
Terraform Cloud module for creating a Linux VM in Azure.

## Module examples
VM deployed VM to a new Resource Group.<br>
<pre>
locals {
  region      = "EastUS"
  environment = "NPE"
}

resource "azurerm_resource_group" "vm_rg" {
  name     = "compute"
  location = local.region

  tags = {
    environment = local.environment
  }
}

module "linux-vm" {
    source                      = "app.terraform.io/ANET/linux-vm/azure"
    version                     = "1.0.0"

    environment_tag             = local.environment

    target_vnet_name            = "VNET-1"
    target_vnet_resource_group  = "VNET-1-RG"
    target_vnet_subnet_name     = "app"

    region                      = local.region
    enable_vm_public_ip         = false
    vm_name                     = "VM1"
    vm_rg_name                  = azurerm_resource_group.vm_rg.name
    vm_size                     = "Standard_DS1_v2"

    delete_disks_on_termination = true
    enable_storage_disk         = true
    os_disk_size                = 64
    storage_disk_size           = 64
    storage_type                = "Standard_LRS"

    vm_hostname                 = "server1"
    vm_username                 = "super"
    vm_user_password            = "P@ssword123!"

    image_publisher             = "RedHat"
    image_offer                 = "RHEL"
    image_sku                   = "7.7"
}
</pre><br><br>



VM deployed to an existing Resource Group.<br>
<pre>
module "linux-vm" {
    source                      = "app.terraform.io/ANET/linux-vm/azure"
    version                     = "1.0.0"

    environment_tag             = local.environment

    target_vnet_name            = "VNET-1"
    target_vnet_resource_group  = "VNET-1-RG"
    target_vnet_subnet_name     = "app"

    region                      = local.region
    enable_vm_public_ip         = false
    vm_name                     = "VM1"
    vm_rg_name                  = azurerm_resource_group.vm_rg.name
    vm_size                     = "Standard_DS1_v2"
    delete_disks_on_termination = true

    vm_hostname                 = "server1"
    vm_username                 = "super"
    vm_user_password            = "P@ssword123!"

    image_publisher             = "RedHat"
    image_offer                 = "RHEL"
    image_sku                   = "7.7"
}
</pre><br><br>
