# Module VPC officiel (Multi-zones, sans NAT Gateway pour des raisons de coût)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}-${var.environment}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Environment = var.environment
  }
}

# 1. Security Group pour l'ALB (ouvert au monde sur le port 80)
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-${var.environment}-alb-sg"
  description = "Security group pour l'Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP depuis Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

# 2. Security Group pour les instances Web (cloisonné : accepte uniquement l'ALB)
resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-${var.environment}-web-sg"
  description = "Security group pour les instances du backend web"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP uniquement depuis l'ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}