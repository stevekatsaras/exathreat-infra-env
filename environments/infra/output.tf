#output mysql address
# ES Endpoint
# Minemeld IP
output "mysql_addr" {
  value       = aws_db_instance.exathreat_mysql.address
  description = "The mysql address"
}
output "es_endpoint" {
  value       = aws_elasticsearch_domain.elasticsearch.endpoint
  description = "The ES Endpoint."
}
output "lb_dns_name" {
  value       = aws_lb.private_web.dns_name
  description = "LB DNS NAME"
}