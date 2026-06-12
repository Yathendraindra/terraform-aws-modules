# ------------------------------------------------------------------------------
# Random suffix to ensure globally unique bucket name
# ------------------------------------------------------------------------------
resource "random_id" "suffix" {
  count       = var.use_random_suffix ? 1 : 0
  byte_length = 4
}

locals {
  bucket_name = var.use_random_suffix ? "${var.name}-${random_id.suffix[0].hex}" : var.name
}

# ------------------------------------------------------------------------------
# S3 Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name = local.bucket_name
  })
}

# ------------------------------------------------------------------------------
# Block all public access by default
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------------------------------------
# Versioning
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# ------------------------------------------------------------------------------
# Server side encryption (AES256 by default, KMS if key provided)
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != "" ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
  }
}

# ------------------------------------------------------------------------------
# Lifecycle Rules
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = lookup(rule.value, "prefix", "")
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration_days", null) != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

# ------------------------------------------------------------------------------
# Bucket Policy (optional)
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "this" {
  count = var.bucket_policy != "" ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy

  depends_on = [aws_s3_bucket_public_access_block.this]
}