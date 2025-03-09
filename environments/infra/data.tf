# exathreat.com
data "aws_acm_certificate" "exathreat_com" {
  domain   = "*.exathreat.com" # format("%s.%s", var.env, var.domain)
  statuses = ["ISSUED"]
}

# exathreat.com Zone
data "aws_route53_zone" "exathreat_com" {
  name = "exathreat.com" # format("%s.%s", var.env, var.domain)
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  cidr_block = var.cidr["vpc"]
}

data "aws_subnet" "publica" {
  tags = {
    Name  = format("%s-subnet-public-a", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_subnet" "publicb" {
  tags = {
    Name  = format("%s-subnet-public-b", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_subnet" "private_weba" {
  tags = {
    Name  = format("%s-subnet-private-web-a", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_subnet" "private_webb" {
  tags = {
    Name  = format("%s-subnet-private-web-b", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_subnet" "private_dba" {
  tags = {
    Name  = format("%s-subnet-private-db-a", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_subnet" "private_dbb" {
  tags = {
    Name  = format("%s-subnet-private-db-b", local.NameTag)
    Owner = var.Owner
  }
}

data "aws_security_group" "public" {
  name = format("%s-sg-bastion", local.NameTag)
}

data "aws_security_group" "api" {
  name = format("%s-sg-api", local.NameTag)
}

data "aws_security_group" "lb" {
  name = format("%s-sg-lb", local.NameTag)
}

data "aws_security_group" "portal" {
  name = format("%s-sg-portal", local.NameTag)
}

data "aws_security_group" "intel" {
  name = format("%s-sg-intel", local.NameTag)
}

data "aws_security_group" "scheduler" {
  name = format("%s-sg-scheduler", local.NameTag)
}

data "aws_security_group" "private_db" {
  name = format("%s-sg-rds", local.NameTag)
}

data "aws_security_group" "elasticsearch" {
  name = format("%s-sg-elasticsearch", local.NameTag)
}

data "aws_ssm_parameter" "prod-exathreat-db-user" {
  name = "prod-exathreat-db-user"
}

data "aws_ssm_parameter" "prod-exathreat-db-pw" {
  name = "prod-exathreat-db-pw"
}

# Dummy ZIP file
data "archive_file" "dummy" {
  type        = "zip"
  output_path = "artifacts/dummy.zip"
  source {
    content  = "hello"
    filename = "dummy.txt"
  }
}