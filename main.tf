variable vpc_id {}
variable app {}
variable environment{}

locals {
   ports_tcp_all = [80,443]
}


resource "aws_security_group" "instace_security_group" {
  vpc_id      = var.vpc_id
  description = "Security group for ${var.app} nodes."
  name        = format("%s-%s-instance-sg", lower(var.app), var.environment)

  dynamic "ingress" {
    for_each = local.ports_tcp_all
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("sg-%s-%s-instance", lower(var.app), var.environment)
    Terraform   = "true"
    Environment = var.environment
    APP         = var.app
  }
}
