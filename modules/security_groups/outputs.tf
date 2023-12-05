output "ec2_eg1_sg_id" {
  value = aws_security_group.ec2_eg1_sg.id
}

output "alb_eg1_sg_id" {
  value = aws_security_group.alb_eg1_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}