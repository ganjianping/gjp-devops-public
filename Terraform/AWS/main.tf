# EC2 Module
module "ec2" {
  count  = var.create_ec2 ? 1 : 0
  source = "./ec2"

  instance_type      = var.instance_type
  os_type            = var.os_type
  ec2_open_tcp_ports = var.ec2_open_tcp_ports
}

# S3 Module
module "s3" {
  count  = var.create_s3 ? 1 : 0
  source = "./s3"

  s3_bucket_name      = var.s3_bucket_name
  enable_versioning   = var.enable_versioning
  enable_encryption   = var.enable_encryption
  block_public_access = var.block_public_access
}
