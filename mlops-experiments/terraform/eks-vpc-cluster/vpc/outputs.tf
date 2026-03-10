output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = [aws_subnet.public.id, aws_subnet.public2.id]
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = [aws_subnet.private.id, aws_subnet.private2.id]
}