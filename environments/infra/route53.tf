# exathreat.com Record (A)
resource "aws_route53_record" "exathreat_com_a_record" {
  name    = format("%s.%s", var.env, var.domain)
  type    = "A"
  zone_id = data.aws_route53_zone.exathreat_com.zone_id
  alias {
    name                   = aws_lb.private_web.dns_name
    zone_id                = aws_lb.private_web.zone_id
    evaluate_target_health = true
  }
}
