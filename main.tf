module "network" {
  source = "./modules/network"
  
  # Variables que pasarás al módulo
  environment = var.environment
  # ...otras variables
}

module "database" {
  source = "./modules/database"
  
  # Variables que pasarás al módulo
  environment = var.environment
  # ...otras variables
  
  # Dependencia del módulo network
  vpc_id           = module.network.vpc_id
  private_subnets  = module.network.private_subnets
}

module "backend" {
  source = "./modules/backend"
  
  # Variables que pasarás al módulo
  environment        = var.environment
  # ...otras variables
  
  # Dependencias de otros módulos
  vpc_id             = module.network.vpc_id
  private_subnets    = module.network.private_subnets
  database_endpoint  = module.database.endpoint
  database_username  = module.database.username
  database_password  = module.database.password
}

module "frontend" {
  source = "./modules/frontend"
  
  # Variables que pasarás al módulo
  environment      = var.environment
  # ...otras variables
  
  # Dependencias de otros módulos
  api_endpoint     = module.backend.api_endpoint
}
