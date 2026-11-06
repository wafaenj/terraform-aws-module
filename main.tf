resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-${var.environment}-custom-sg"
  description = "Standard security group managed by team"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.environment
  }
}
