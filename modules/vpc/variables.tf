variable "name" {
    description = "Name prefix of all resources"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR block for the vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "List of Azs to deploy subnets into"
    type = list(string)
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for public subnets (one per AZ)"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "CIDR blocks for private subnets (one per AZ)"
    type = list(string)
}

variable "single_nat_gateway" {
    description = "Use one NAT Gateway for all Azs (cost saving for non-prod)"
    type = bool
    default = false
}

variable "tags" {
    description = "Tags to apply to all resources"
    type = map(string)
    default = {}
}