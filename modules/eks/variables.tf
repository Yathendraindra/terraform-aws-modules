variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "vpc_id" {
  description = "VPC ID to deploy the EKS cluster into"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs (used for load balancers)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (node groups run here)"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Enable public API endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDRs allowed to access the public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_log_types" {
  description = "EKS control plane log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "node_groups" {
  description = "Map of node group configurations"
  type        = any
  default = {
    general = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 5
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
    }
  }
}

variable "cluster_addons" {
  description = "Map of EKS add-ons to install"
  type        = any
  default = {
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
    aws-ebs-csi-driver = {}
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}