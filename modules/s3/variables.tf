variable "name" {
  description = "Base name for the S3 bucket"
  type        = string
}

variable "use_random_suffix" {
  description = "Append a random suffix to ensure bucket name uniqueness"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Enable object versioning"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket deletion even when it contains objects"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for SSE-KMS encryption. Leave empty for AES256"
  type        = string
  default     = ""
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type        = any
  default     = []
}

variable "bucket_policy" {
  description = "JSON bucket policy document. Leave empty for no policy"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}