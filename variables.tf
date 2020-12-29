variable "target_vnet_name" {
    type = string
    default = "NPE-EastUS-SonarQube-VNET"
    description = "The name of the VNET the VM should be deployed to."
}

variable "target_vnet_resource_group" {
    type = string
    default = "NPE-EastUS-SonarQube-Network-RG"
    description = "The name of the Resource Group the target VNET belongs to."
}

variable "target_vnet_subnet_name" {
    type = string
    default = "app"
    description = "The name of the target subnet within the VNET."
}

variable "enable_vm_public_ip" {
    type = bool
    default = false
    description = "Enables a public IP on the VM, requires a public subnet."
}

variable "vm_rg_name" {
    type = string
    default = "NPE-EastUS-SonarQube-RG"
    description = "The of a Resourse Group to create or add to."
}

variable "vm_name" {
    type = string
    default = "VM1"
    description = "The name of the Virtual Machine."
}

variable "region" {
    type = string
    default = "EastUS"
    description = "Azure region for VM."
}

variable "environment_tag" {
    type = string
    default = "NPE"
    description = "The type of environment."
}

variable "delete_disks_on_termination" {
    type = bool
    default = false
    description = "Deletes the storage disks when VM is terminated."
}

variable "vm_size" {
    type = string
    default = "Standard_DS1_v2"
    description = "The size of the VM."
}

variable "vm_hostname" {
    type = string
    default = "server1"
    description = "The hostname of the VM."
}

variable "vm_username" {
    type = string
    default = "super"
    description = "The username for the VM."
}

variable "vm_user_password" {
    type = string
    default = "P@ssword123!"
    description = "The password for the admin user."
}

variable "enable_storage_disk" {
    type = bool
    default = false
    description = "Adds an additional storage disk to the VM."
}

variable "os_disk_size" {
    type = number
    default = 128
    description = "The size in GB for the Operating System disk."
}

variable "storage_disk_size" {
    type = number
    default = 128
    description = "The size in GB for the storage disk."
}

variable "storage_type" {
    type = string
    default = "Standard_LRS"
    description = "Storage class for the disks."
}

variable "image_publisher" {
    type = string
    default = "RedHat"
    description = "Specifies the publisher of the image used to create the virtual machines."
}

variable "image_offer" {
    type = string
    default = "RHEL"
    description = "Specifies the offer of the image used to create the virtual machines."
}

variable "image_sku" {
    type = string
    default = "7.7"
    description = "Specifies the SKU of the image used to create the virtual machines."
}