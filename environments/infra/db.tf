# Subnet Group
resource "aws_db_subnet_group" "db_group" {
  name       = format("private_db_subnet_%s", var.env)
  subnet_ids = [data.aws_subnet.private_dba.id, data.aws_subnet.private_dbb.id]
}

# DB Instance
resource "aws_db_instance" "exathreat_mysql" {
  identifier                  = format("%s-%s-%s-mysql", var.env, var.RegCode, var.Product)
  name                        = var.Product
  allocated_storage           = var.db_alloc_storage
  max_allocated_storage       = var.db_max_storage
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.20"
  instance_class              = var.db_instance_class
  username                    = data.aws_ssm_parameter.prod-exathreat-db-user.value
  password                    = data.aws_ssm_parameter.prod-exathreat-db-pw.value
  db_subnet_group_name        = aws_db_subnet_group.db_group.name
  vpc_security_group_ids      = [data.aws_security_group.private_db.id]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true
  skip_final_snapshot         = true
  tags = {
    Name  = format("%s%s%sMysql", var.env, var.RegCode, var.Product)
    Owner = var.Owner
  }
}

provider "mysql" {
  endpoint = aws_db_instance.exathreat_mysql.endpoint
  username = aws_db_instance.exathreat_mysql.username
  password = aws_db_instance.exathreat_mysql.password
}

#resource "mysql_user" "portal" {
#  user = "portal"
#  host = aws_db_instance.exathreat_mysql.address
#  plaintext_password = data.aws_ssm_parameter.prod-exathreat-db-pw.value
#  depends_on          = [aws_db_instance.exathreat_mysql]
#}

#resource "mysql_user" "api" {
#  user = "api"
#  host = aws_db_instance.exathreat_mysql.address
#  plaintext_password = data.aws_ssm_parameter.prod-exathreat-db-pw.value
#  depends_on          = [aws_db_instance.exathreat_mysql]
#}

#resource "mysql_user" "user" {
#  for_each           = var.mysql_users
#  user               = each.value
#  host               = "%"
#  tls_option         = "NONE"
#  plaintext_password = random_password.test[each.value].result
#}
#resource "mysql_user" "portal" {
#  for_each           = var.mysql_users
#  user               = "portal"
#  host = aws_db_instance.exathreat_mysql.address
#  tls_option         = "SSL"
#  plaintext_password = random_password.test[each.value].result
#}

#resource "mysql_grant" "test" {
#  for_each   = var.mysql_grants
#  user       = mysql_user.test[each.value["name"]].user
#  host       = "%"
#  database   = each.value["database"]
#  privileges = each.value["grant"]
#}

#resource "random_password" "test" {
#  for_each = var.mysql_users
#  length   = 32
#  special  = false
#}

#variable "mysql_users" {
#  type    = map(string)
#  default = {
#    portal   = "portal"
#    api      = "api"
#  }
#}