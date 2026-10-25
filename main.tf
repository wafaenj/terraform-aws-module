resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-${var.environment}-custom-sg"
  description = "Security group standard gere par le module d'equipe"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.environment
  }
}
