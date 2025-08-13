terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {}

variable "instance_name" {}

variable "instance_type" {}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "open_all" {
  name        = "${var.instance_name}-sg"
  description = "Open all ports"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = "ami-08c40ec9ead489470" # Ubuntu 22.04 en us-east-1
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.open_all.name]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
                sudo apt-get update -y
                sudo apt-get upgrade -y
                sudo apt-get install docker.io docker-compose git -y
                git clone https://github.com/DefectDojo/django-DefectDojo.git
                cd django-DefectDojo
                sudo docker-compose up -d
              EOF

  tags = {
    Name = var.instance_name
  }
}

output "instance_ip" {
  value = aws_instance.ec2.public_ip
}
