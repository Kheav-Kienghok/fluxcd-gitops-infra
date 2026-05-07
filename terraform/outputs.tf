output "ec2_public_ip" {
  description = "EC2 instance public IP address"
  value       = aws_instance.ec2.public_ip
}

output "ec2_url" {
  description = "EC2 instance HTTP URL"
  value       = "http://${aws_instance.ec2.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = "ssh -i ../secret/ec2_key.pem ubuntu@${aws_instance.ec2.public_ip}"
}

output "ansible_inventory_entry" {
  description = "Inventory line to paste into ansible/inventory.ini"
  value       = "${aws_instance.ec2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../secret/ec2_key.pem"
}
