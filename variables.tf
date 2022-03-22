# General

variable "location" {
  type = string
  description = "Region for deployment"
}

variable "tags" {
  type = map
  description = "Tags"
}

# Resource Group

variable "rg_name" {
    type = string
    description = "Resource group name"
}

# Virtual Network

variable "vnet_name" {
      description = "vNet Name"
      type = string
}

variable "vnet_address_space" {
      description = "vNet Address Space"
      type = list
}

variable "admuser" {
      description = "Admin User"
      type = string
}

variable "admpass" {
      description = "Admin Password"
      type = string
      sensitive = true
}

# Subnet

variable "subnet_name" {
      description = "Subnet Name"
      type = string
}

variable "subnet_address_prefixes" {
      description = "Subnet Prefixes"
      type = list
}
