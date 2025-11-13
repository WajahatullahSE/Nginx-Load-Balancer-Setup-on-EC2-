data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = [var.ami_owner]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Load Balancer (public)
resource "aws_instance" "lb" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_public_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata-lb.sh")

  tags = {
    Name        = "${var.env_tag}-lb"
    Environment = var.env_tag
  }
}

# Backend server 1 (private)
resource "aws_instance" "backend1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_private_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  associate_public_ip_address = false

  private_ip = "10.0.2.100"

  user_data = file("${path.module}/userdata-backend.sh")

  tags = {
    Name        = "${var.env_tag}-backend1"
    Environment = var.env_tag
  }
}

# Backend server 2 (private)
resource "aws_instance" "backend2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_private_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  associate_public_ip_address = false

  private_ip = "10.0.2.101"

  user_data = file("${path.module}/userdata-backend.sh")

  tags = {
    Name        = "${var.env_tag}-backend2"
    Environment = var.env_tag
  }
}
