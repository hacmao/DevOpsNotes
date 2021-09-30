output "vpc_id" {
  value = aws_vpc.main.*.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}
