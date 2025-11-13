output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_id" { value = module.network.public_subnet_id }
output "private_subnet_id" { value = module.network.private_subnet_id }
output "nat_id" { value = module.network.nat_id }
output "lb_public_ip" { value = module.ec2.lb_public_ip }
output "backend_private_ips" { value = module.ec2.backend_private_ips }
