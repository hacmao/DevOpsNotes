data "aws_route53_zone" "route53" {
  name = var.domain_name
}

resource "aws_acm_certificate" "acm" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "route53_record" {
  name    = tolist(aws_acm_certificate.acm.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.acm.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.route53.zone_id
  records = [tolist(aws_acm_certificate.acm.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [aws_route53_record.route53_record.fqdn]
}
