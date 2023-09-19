module "west-eu-hub-01" {
  source                 = "./modules/hub"
  rg_name                = "drs-ghost-hub-rg01"
  location               = "westeurope"
  vnet_address_space     = ["192.168.1.0/24"]
  default_subnet_address = ["192.168.1.0/26"]
  tags = {    
    "Application" = "Ghost"
  }
}