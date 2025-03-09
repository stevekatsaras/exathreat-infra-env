#resource "aws_eip" "nat" {
#  count = length(var.azs)
#  instance = aws_instance.nat.id
#  vpc   = true
#  tags = {
#    Name  = format("%s-NAT-%s", local.NameTag, var.azs[count.index])
#    Owner = var.Owner
#  }
#}

#resource "aws_nat_gateway" "nat_gw" {
#  count         = length(var.azs)
#  allocation_id = aws_eip.nat[count.index].id
#  subnet_id     = aws_subnet.public[count.index].id
#  tags = {
#    Name  = format("%s-NAT-gw-%s", local.NameTag, var.azs[count.index])
#    Owner = var.Owner
#  }
#}

#data "aws_ami" "ubuntu" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }
#
# filter {
#   name   = "virtualization-type"
#   values = ["hvm"]
# }

#  owners = ["099720109477"] # Canonical
#}

#resource "aws_instance" "nat" {
#  ami           = data.aws_ami.ubuntu.id
#  instance_type = "t3.micro"

#tags = {
#    Name  = format("%s-NAT-EC2-%s", local.NameTag, var.azs[count.index])
#    Owner = var.Owner
#  }
#}