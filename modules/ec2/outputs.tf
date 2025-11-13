output "lb_public_ip" { value = aws_instance.lb.public_ip }
output "lb_public_id" { value = aws_instance.lb.id }
output "backend_private_ips" {
  value = [aws_instance.backend1.private_ip, aws_instance.backend2.private_ip]
}
output "backend_instance_ids" {
  value = [aws_instance.backend1.id, aws_instance.backend2.id]
}
