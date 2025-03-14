resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = format("%s-igw", local.NameTag)
    Owner = var.Owner
  }
}