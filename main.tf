
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

module "publicip" {
  count = 2
  source = "github.com/cbuxton1984/terraform_modules/public_ip"
  pi_name = "Win2K19-demo-publicip-${count.index}"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}

# Virtual Machines

module "windows_vm_2019" {
  count = 1
  source ="github.com/cbuxton1984/terraform_modules/win_vm"
  vm_name = "win2k19-demo-${count.index + 1}"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B2s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "2019-Datacenter"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publicip.publicip_id
  tags = var.tags
}
