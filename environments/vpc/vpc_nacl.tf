## Public NACL
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = concat(aws_subnet.private_web[*].id, aws_subnet.public[*].id)
  tags = {
    Name  = format("%s-nacl-public", local.NameTag)
    Owner = var.Owner
  }
}

# Public NACL allow all traffic by default. 
resource "aws_network_acl_rule" "public_block_in" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Allow all network out 
resource "aws_network_acl_rule" "public_allow_out" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

## Private NACL
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private_db[*].id
  tags = {
    Name  = format("%s-nacl-private", local.NameTag)
    Owner = var.Owner
  }
}

# Allow all network. As public blocks all and unblocking is on demand this will not pose a problem
resource "aws_network_acl_rule" "private_allow_in" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Allow all network out 
resource "aws_network_acl_rule" "private_allow_out" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}