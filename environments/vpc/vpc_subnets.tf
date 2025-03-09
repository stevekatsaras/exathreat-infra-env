## Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = format("%s%s", var.region, var.azs[count.index])
  cidr_block        = var.cidr[format("public-%s", var.azs[count.index])]
  tags = {
    Name  = format("%s-subnet-public-%s", local.NameTag, var.azs[count.index])
    Owner = var.Owner
  }
}

## Private Web
resource "aws_subnet" "private_web" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = format("%s%s", var.region, var.azs[count.index])
  cidr_block        = var.cidr[format("private-web-%s", var.azs[count.index])]
  tags = {
    Name  = format("%s-subnet-private-web-%s", local.NameTag, var.azs[count.index])
    Owner = var.Owner
  }
}

## Private DB
resource "aws_subnet" "private_db" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = format("%s%s", var.region, var.azs[count.index])
  cidr_block        = var.cidr[format("private-db-%s", var.azs[count.index])]
  tags = {
    Name  = format("%s-subnet-private-db-%s", local.NameTag, var.azs[count.index])
    Owner = var.Owner
  }
}