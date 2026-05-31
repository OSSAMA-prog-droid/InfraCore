module "networking" {
  source      = "../../modules/networking"
  environment = var.environment
  vpc_cidr    = "10.1.0.0/16"
}

module "database" {
  source      = "../../modules/database"
  environment = var.environment
  db_username = var.db_username
  db_password = var.db_password
  subnet_ids  = module.networking.private_subnet_ids
  vpc_id      = module.networking.vpc_id
  app_sg_id   = module.networking.app_sg_id
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
}
