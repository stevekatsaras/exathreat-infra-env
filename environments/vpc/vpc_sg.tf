# GET Running ENV IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

## Public VPC SG
resource "aws_security_group" "public" {
  name        = format("%s-sg-bastion", local.NameTag)
  description = "Security Group for Public Load Balancers and Applications"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-bastion", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "public_allow_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
  description       = "public_allow_ssh"
}

resource "aws_security_group_rule" "public_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

## intel
resource "aws_security_group" "intel" {
  name        = format("%s-sg-intel", local.NameTag)
  description = "Security Group for Front End layer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-intel", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "intel_allow_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.intel.id
  description       = "intel_allow_ssh"
}

resource "aws_security_group_rule" "intel_allow_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.intel.id
  description       = "intel_allow_http"
}

resource "aws_security_group_rule" "intel_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.intel.id
  description       = "intel_allow_https"
}

resource "aws_security_group_rule" "intel_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.intel.id
}

## Portal
resource "aws_security_group" "portal" {
  name        = format("%s-sg-portal", local.NameTag)
  description = "Security Group for Front End layer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-portal", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "portal_allow_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.portal.id
  description       = "portal_allow_ssh"
}

resource "aws_security_group_rule" "portal_allow_portal" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.portal.id
  description       = "portal_allow_portal"
}

resource "aws_security_group_rule" "portal_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.portal.id
  description       = "portal_allow_https"
}

resource "aws_security_group_rule" "portal_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.portal.id
}

## Api
resource "aws_security_group" "api" {
  name        = format("%s-sg-api", local.NameTag)
  description = "Security Group for api"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-api", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "api_allow_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.api.id
  description       = "api_allow_ssh"
}

resource "aws_security_group_rule" "api_allow_portal" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.api.id
  description       = "api_allow_portal"
}

resource "aws_security_group_rule" "api_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.api.id
  description       = "api_allow_https"
}

resource "aws_security_group_rule" "api_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.api.id
}

## LoadBalancer
resource "aws_security_group" "lb" {
  name        = format("%s-sg-lb", local.NameTag)
  description = "Security Group for Front End layer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-lb", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "lb_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
  description       = "lb_allow_https"
}

resource "aws_security_group_rule" "lb_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

## Private DB
resource "aws_security_group" "private_db" {
  name        = format("%s-sg-rds", local.NameTag)
  description = "Security Group for Database Layer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-rds", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "private_db_allow_rds" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.private_db.id
  description       = "private_db_allow_rds"

}

resource "aws_security_group_rule" "allow_env_ip" {
  type              = "ingress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.private_db.id
  description       = "private_db_allow_rds"

}

resource "aws_security_group_rule" "private_db_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_db.id
}

## Elasticsearch
resource "aws_security_group" "elasticsearch" {
  name        = format("%s-sg-elasticsearch", local.NameTag)
  description = "Security Group for Elasticsearch"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-elasticsearch", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "elasticsearch_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.elasticsearch.id
  description       = "elasticsearch_allow_https"
}

resource "aws_security_group_rule" "elasticsearch_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elasticsearch.id
}

## Scheduler
resource "aws_security_group" "scheduler" {
  name        = format("%s-sg-scheduler", local.NameTag)
  description = "Security Group for Front End layer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name  = format("%s-sg-scheduler", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_security_group_rule" "scheduler_allow_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.scheduler.id
  description       = "scheduler_allow_ssh"
}

resource "aws_security_group_rule" "scheduler_allow_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.scheduler.id
  description       = "scheduler_allow_http"
}

resource "aws_security_group_rule" "scheduler_allow_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.cidr["vpc"]]
  security_group_id = aws_security_group.scheduler.id
  description       = "scheduler_allow_https"
}

resource "aws_security_group_rule" "scheduler_allow_out" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.scheduler.id
}