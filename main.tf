module "vpc_creation" {
  source = "./modules/vpc"
  vpc_name = "myvpc"
  app_region= "us-east-1"
  vpc_cidir = "10.0.0.0/16"
  public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24", "10.0.4.0/24"]
  private_subnets_cidr = ["10.0.5.0/24", "10.0.6.0/24","10.0.7.0/24", "10.0.8.0/24"]
  public_azs = ["us-east-1a", "us-east-1b","us-east-1c", "us-east-1d"]
  private_azs = ["us-east-1a", "us-east-1b","us-east-1c", "us-east-1d"]
}