output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "private_subnet_id" { value = aws_subnet.private.id }
output "igw_id" { value = aws_internet_gateway.this.id }
output "nat_id" { value = aws_nat_gateway.this.id }
output "public_route_table_id" { value = aws_route_table.public_rt.id }
output "private_route_table_id" { value = aws_route_table.private_rt.id }
