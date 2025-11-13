# Public SG (Load Balancer) -- HTTP/HTTPS open, SSH from your IP
resource "aws_security_group" "public_sg" {
  name        = "${var.env_tag}-public-sg"
  vpc_id      = var.vpc_id
  description = "Public SG for load balancer"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH from admin IP"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env_tag}-public-sg", Environment = var.env_tag }
}

# Private SG (Backend) -- only allow traffic from the public SG
resource "aws_security_group" "private_sg" {
  name        = "${var.env_tag}-private-sg"
  vpc_id      = var.vpc_id
  description = "Private SG for backend servers"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "HTTP from public LB"
  }

  # optional - allow SSH from public SG for management
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "SSH from public LB (admin via bastion)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env_tag}-private-sg", Environment = var.env_tag }
}
