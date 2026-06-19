output "s3_bucket_name" {
  description = "Name of the S3 bucket created for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table created for state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "backend_config" {
  description = "Copy this into your root module's backend.tf"
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "<your-project>/terraform.tfstate"
        region         = "${var.aws_region}"
        dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
        encrypt        = true
      }
    }
  EOT
}