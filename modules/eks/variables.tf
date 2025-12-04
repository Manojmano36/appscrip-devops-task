
# EKS module - variables.tf


variable "region" {
  description = "AWS region for resources (module-level)."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed (not directly used here but useful to keep)."
  type        = string
}

variable "subnet_id" {
  description = "List of subnet IDs (private subnets recommended) where cluster and nodes will be placed."
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster to create."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane, e.g. \"1.27\"."
  type        = string
}

variable "node_groups" {
  description = "Map of managed node group definitions. Keys are node group names."
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}
