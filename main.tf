module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
  env_tag             = var.env_tag
}

module "security" {
  source  = "./modules/security"
  vpc_id  = module.network.vpc_id
  env_tag = var.env_tag
  my_ip   = var.my_ip
  public_subnet_id = module.network.public_subnet_id
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_public_id  = module.network.public_subnet_id
  subnet_private_id = module.network.private_subnet_id
  key_name          = var.key_name
  instance_type     = var.instance_type
  env_tag           = var.env_tag
  ami_owner         = var.ami_owner
  public_sg_id      = module.security.public_sg_id
  private_sg_id     = module.security.private_sg_id
}
