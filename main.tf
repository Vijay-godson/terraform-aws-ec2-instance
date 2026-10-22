resource "tls_private_key" "instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.instance.public_key_openssh
}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
  tags = {
    Name  = var.instance_name
    Owner = var.owner
  }
}
