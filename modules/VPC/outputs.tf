# export region
output "region" {
  value = var.region
}
# export project name
output "project_name" {
  value = var.project_name
}
# export vpc id
output "vpc_id" {
  value = aws_vpc.vpc.id
}
# export internet gateway id
output "internet_gateway" {
  value = aws_internet_gateway.gw
}
# export public subnet 1 id
output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}
# export public subnet 2 id
output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}
# export private subnet 1 id
output "private_subnet1_id" {
  value = aws_subnet.private_sub1.id
}
# export private subnet 2 id
output "private_subnet2_id" {
  value = aws_subnet.private_sub2.id
}
# export az1
output "az1" {
  value = data.aws_availability_zones.available.names[0]
}
# export az2
output "az2" {
  value = data.aws_availability_zones.available.names[1]
}
