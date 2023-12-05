terraform {
  backend "s3" {
    bucket  = "proj-bucket-cloud"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source         = "./modules/ec2"
  instance_count = 1

  ami_id = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name      = "caiorp"

  vpc_id                      = module.vpc.vpc_id
  public_us_east_1a_id        = module.vpc.public_us_east_1a_id
  public_us_east_1b_id        = module.vpc.public_us_east_1b_id
  private_us_east_1a_id       = module.vpc.private_us_east_1a_id
  private_us_east_1b_id       = module.vpc.private_us_east_1b_id

  ec2_eg1_sg_id               = module.security_groups.ec2_eg1_sg_id
  alb_eg1_sg_id               = module.security_groups.alb_eg1_sg_id
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  vpc_id                     = module.vpc.vpc_id

  private_us_east_1a_id      = module.vpc.private_us_east_1a_id
  private_us_east_1b_id      = module.vpc.private_us_east_1b_id

  rds_sg_id                  = module.security_groups.rds_sg_id

  db_username                = var.db_username
  db_password                = var.db_password
  db_name                    = var.db_name
}