#########################################
# Root main.tf
#########################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# --------------------------
# VPC Module
# --------------------------
module "vpc" {
  source             = "./modules/vpc"
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones = var.availability_zones
  eks_cluster_name   = var.eks_cluster_name
}

# --------------------------
# EKS Module
# --------------------------
module "eks" {
  source           = "./modules/eks"
  region           = var.region
  eks_cluster_name = var.eks_cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.private_subnet_ids
  node_groups      = var.node_groups
}
