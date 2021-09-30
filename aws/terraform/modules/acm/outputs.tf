output "acm_arn" {
  value = aws_acm_certificate.acm.arn
}

output "validation" {
  value = tolist(aws_acm_certificate.acm.domain_validation_options)
}
