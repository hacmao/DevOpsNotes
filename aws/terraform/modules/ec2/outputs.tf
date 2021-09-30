output "ec2_domain" {
  value = aws_instance.webapp.public_dns
}
