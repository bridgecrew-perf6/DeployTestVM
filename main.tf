
# Resource Group

module "rg" {
  source = "github.com/cbuxton1984/terraform_modules/rg"
  rg_name = var.rg_name
  rg_location = var.location
  rg_tags = var.tags
}

# Networking

module "vnet" {
  source = "github.com/cbuxton1984/terraform_modules/vnet"
  vnet_name = "${var.rg_name}-${var.vnet_name}"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vnet_address_space = var.vnet_address_space
  tags = var.tags
}

module "subnet" {
  source = "github.com/cbuxton1984/terraform_modules/subnet"
  subnet_name = "${var.rg_name}-${var.vnet_name}-${var.subnet_name}"
  vnet_name = module.vnet.vnet_name
  rg_name = module.rg.rg_name
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "publicipwin" {
  source = "github.com/cbuxton1984/terraform_modules/public_ip"
  pi_name = "windows-demo-vm-publicip"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}

module "publiciprhel" {
  source = "github.com/cbuxton1984/terraform_modules/public_ip"
  pi_name = "rhel-demo-vm-publicip"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}

# Virtual Machines Windows

module "windows_vm_2019" {
  source ="github.com/cbuxton1984/terraform_modules/win_vm"
  vm_name = "windows-demo-vm"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B1s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "2019-Datacenter"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publicipwin.publicip_id
  tags = var.tags
}

# Virtual Machines RHEL

module "rhel_vm" {
  source ="github.com/cbuxton1984/terraform_modules/rhel_vm"
  vm_name = "rhel-demo-vm"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B1s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "76-gen2"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publiciprhel.publicip_id
  tags = var.tags
}