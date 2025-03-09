resource "aws_vpc" "main" {
  cidr_block           = var.cidr["vpc"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name  = local.NameTag
    Owner = var.Owner
  }
}

resource "aws_vpc_dhcp_options" "dns" {
  domain_name         = format("%s.compute.internal", var.region)
  domain_name_servers = ["AmazonProvidedDNS"]
}

## Associated dhcp options with VPC
resource "aws_vpc_dhcp_options_association" "resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dns.id
}