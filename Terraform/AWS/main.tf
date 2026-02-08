# EC2 Module
module "ec2" {
    count  = var.create_ec2 ? 1 : 0
    source = "./ec2"

    environment        = var.environment
    instance_type      = var.instance_type
    os_type            = var.os_type
    ec2_open_tcp_ports = var.ec2_open_tcp_ports
    ami_id             = var.ami_id
    instance_name      = var.instance_name
    key_name           = var.key_name
    public_key_path    = var.public_key_path
    enable_public_ip   = var.enable_public_ip
    allowed_ssh_cidr   = var.allowed_ssh_cidr
    root_volume_size   = var.root_volume_size
    root_volume_type   = var.root_volume_type
    subnet_id          = var.subnet_id
    vpc_id             = var.vpc_id
    additional_tags    = var.additional_tags
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
