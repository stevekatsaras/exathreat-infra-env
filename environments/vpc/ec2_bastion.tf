resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  root_block_device {
    volume_type = "standard"
    volume_size = "8"
  }
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.public.id]
  key_name               = aws_key_pair.bastion_kp.key_name
  tags = {
    Name  = format("%s-ec2-bastion", local.NameTag)
    Owner = var.Owner
  }
}

# Bastion Key Pair
resource "aws_key_pair" "bastion_kp" {
  key_name   = format("%s-exathreat-kp", var.env)
  public_key = file("artifacts/ssh-keys/exathreat-key.pub")
}