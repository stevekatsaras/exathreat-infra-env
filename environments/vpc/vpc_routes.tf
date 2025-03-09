## Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = format("%s-rt-public", local.NameTag)
    Owner = var.Owner
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_web" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private_web[count.index].id
  route_table_id = aws_route_table.public.id
}

## Private

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(var.azs)
  tags = {
    Name  = format("%s-rt-private-%s", local.NameTag, var.azs[count.index])
    Owner = var.Owner
  }
}

#resource "aws_route" "private" {
#  count                  = length(var.azs)
#  route_table_id         = aws_route_table.private[count.index].id
#  destination_cidr_block = "0.0.0.0/0"
#  insert NAT here
#}

resource "aws_route_table_association" "private_db" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
