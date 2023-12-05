resource "aws_security_group" "ec2_eg1_sg" {
  name   = "ec2-eg1"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "alb_eg1_sg" {
  name   = "alb-eg1"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_ec2_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1_sg.id
  source_security_group_id = aws_security_group.alb_eg1_sg.id
}

resource "aws_security_group_rule" "ingress_ec2_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1_sg.id
  source_security_group_id = aws_security_group.alb_eg1_sg.id
}

resource "aws_security_group_rule" "ingress_ec2_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "full_egress_ec2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ec2_eg1_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_eg1_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_traffic" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb_eg1_sg.id
  source_security_group_id = aws_security_group.ec2_eg1_sg.id
}

resource "aws_security_group_rule" "egress_alb_health_check" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_eg1_sg.id
  source_security_group_id = aws_security_group.ec2_eg1_sg.id
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  vpc_id = var.vpc_id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# resource "aws_security_group" "alb_eg1_sg" {
#   name        = "alb-sg"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }

# resource "aws_security_group" "ec2_eg1_sg" {
#   name        = "ec2-sg"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_eg1_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ec2-sg"
#   }
# }