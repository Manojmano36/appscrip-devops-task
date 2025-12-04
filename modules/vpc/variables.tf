variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZ list matching subnet CIDRs"
}

variable "eks_cluster_name" {
  type        = string
  description = "Cluster name for tagging"
}
