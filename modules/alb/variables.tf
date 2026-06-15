variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to deploy the ALB into"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Set to true for an internal ALB"
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Port the target instances are listening on"
  type        = number
  default     = 80
}

variable "target_type" {
  description = "Target type: instance, ip, or lambda"
  type        = string
  default     = "instance"
}

variable "target_instance_ids" {
  description = "EC2 instance IDs to attach to the target group"
  type        = list(string)
  default     = []
}

variable "health_check_path" {
  description = "Path for ALB health checks"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP status codes for a healthy response"
  type        = string
  default     = "200-399"
}

variable "enable_https" {
  description = "Enable HTTPS listener with redirect from HTTP"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS. Required if enable_https is true"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
