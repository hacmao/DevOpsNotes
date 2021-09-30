data "aws_route53_zone" "route53" {
  name = var.domain_name
}

//resource "aws_route53_record" "lb_record" {
//  name = "api.${var.domain_name}"
//  type = "CNAME"
//  zone_id = data.aws_route53_zone.route53.zone_id
//  records = [aws_lb.api_lb.dns_name]
//  ttl = 300
//}

resource "aws_route53_record" "lb_record" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.route53.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_lb.api_lb.dns_name
    zone_id                = aws_lb.api_lb.zone_id
  }
}
