resource "tls_private_key" "instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.instance.public_key_openssh
}

resource "aws_security_group" "app" {
  name        = "${var.instance_name}-app-sg"
  description = "HTTP access to the application on ${var.instance_name}"

  ingress {
    description = "HTTP for the application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.app_ingress_cidr] #tfsec:ignore:aws-ec2-no-public-ingress-sgr
  }
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr] #tfsec:ignore:aws-ec2-no-public-ingress-sgr
  }

  egress {
    description = "Outbound for image pulls, DNS and updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = {
    Name = "${var.instance_name}-app-sg"
  }
}

resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOF
    #!/bin/bash
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y && apt-get install -y docker.io
    else
      yum install -y docker
    fi
    systemctl enable --now docker
    for i in 1 2 3 4 5; do docker info >/dev/null 2>&1 && break; sleep 2; done
    docker run -d --restart unless-stopped --name app -p 80:80 ${var.docker_image}
  EOF

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
