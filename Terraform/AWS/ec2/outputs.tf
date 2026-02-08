output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.app_server.instance_state
}

output "ec2_ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = aws_instance.app_server.ami
}

output "ec2_security_group_id" {
  description = "Security group ID attached to the EC2 instance"
  value       = aws_security_group.ec2_sg.id
}

// SSH command to use correct username per OS type, if var.key_name != ""  then use ~/.ssh/${var.key_name}.pem, else use ~/.ssh/id_rsa to connect
output "ssh_command" {
  description = "SSH command to connect to the instance based on OS type"
    value = var.key_name != "" ? (
        var.os_type == "ubuntu" ? "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.app_server.public_ip}" :
        (var.os_type == "amazon-linux-2" || var.os_type == "amazon-linux-2023") ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.app_server.public_ip}" :
        var.os_type == "rhel" ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.app_server.public_ip}" :
        var.os_type == "debian" ? "ssh -i ~/.ssh/${var.key_name}.pem admin@${aws_instance.app_server.public_ip}" :
        var.os_type == "centos" ? "ssh -i ~/.ssh/${var.key_name}.pem centos@${aws_instance.app_server.public_ip}" :
        var.os_type == "windows-2022" || var.os_type == "windows-2019" ? "Use RDP to connect to ${aws_instance.app_server.public_ip}" :
        "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.app_server.public_ip}"
    ) : (
        var.os_type == "ubuntu" ? "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.app_server.public_ip}" :
        (var.os_type == "amazon-linux-2" || var.os_type == "amazon-linux-2023") ? "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.app_server.public_ip}" :
        var.os_type == "rhel" ? "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.app_server.public_ip}" :
        var.os_type == "debian" ? "ssh -i ~/.ssh/id_rsa admin@${aws_instance.app_server.public_ip}" :
        var.os_type == "centos" ? "ssh -i ~/.ssh/id_rsa centos@${aws_instance.app_server.public_ip}" :
        var.os_type == "windows-2022" || var.os_type == "windows-2019" ? "Use RDP to connect to ${aws_instance.app_server.public_ip}" :
        "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.app_server.public_ip}"
    )   
}