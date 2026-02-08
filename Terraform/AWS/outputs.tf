# EC2 Outputs
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].ec2_public_ip : null
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].ec2_instance_id : null
}

output "ec2_ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].ec2_ami_id : null
}

output "ec2_security_group_id" {
  description = "Security group ID attached to the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].ec2_security_group_id : null
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].instance_state : null
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = var.create_ec2 ? module.ec2[0].instance_private_ip : null
}

output "ssh_command" {
  description = "SSH command to connect to the instance based on OS type"
  value       = var.create_ec2 ? module.ec2[0].ssh_command : null
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.create_s3 ? module.s3[0].s3_bucket_name : null
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = var.create_s3 ? module.s3[0].s3_bucket_arn : null
}

output "s3_bucket_region" {
  description = "AWS region where the S3 bucket is located"
  value       = var.create_s3 ? module.s3[0].s3_bucket_region : null
}

output "s3_bucket_domain_name" {
  description = "Bucket domain name"
  value       = var.create_s3 ? module.s3[0].s3_bucket_domain_name : null
}
