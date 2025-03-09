output "bastion_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The Bastion IP."
}
