output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.this[*].id
}

output "instance_public_ips" {
  description = "List of public IPs (empty if no public IP assigned)"
  value       = aws_instance.this[*].public_ip
}

output "instance_private_ips" {
  description = "List of private IPs"
  value       = aws_instance.this[*].private_ip
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to EC2"
  value       = aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "Name of the IAM role attached to EC2"
  value       = aws_iam_role.this.name
}