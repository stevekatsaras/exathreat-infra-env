# exathreat.com Certificate
resource "aws_acm_certificate" "exathreat" {
  domain_name       = format("*.%s", var.domain)
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# exathreat.com Certificate Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.exathreat.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}

# exathreat.com Record (Certificate Validation)
resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.exathreat.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  type    = each.value.type
  zone_id = data.aws_route53_zone.exathreat.zone_id
  records = [each.value.record]
  ttl     = "60"
}

# exathreat.com Hosted Zone
data "aws_route53_zone" "exathreat" {
  name = var.domain
}
