output "vpc_id" {
  value       = aws_vpc.main.id
}

output "public_us_east_1a_id" {
  value       = aws_subnet.public_us_east_1a.id
}

output "public_us_east_1b_id" {
  value       = aws_subnet.public_us_east_1b.id
}

output "private_us_east_1a_id" {
  value       = aws_subnet.private_us_east_1a.id
}

output "private_us_east_1b_id" {
  value       = aws_subnet.private_us_east_1b.id
}