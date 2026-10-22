output "instance_public_ip" {
  value       = aws_instance.instance.public_ip
  description = "Public IP of the EC2 instance"
}

output "private_key_pem" {
  value     = tls_private_key.instance.private_key_pem
  sensitive = true
}
