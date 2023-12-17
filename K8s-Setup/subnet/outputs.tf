output "subnet_ids" {
  value = aws_subnet.subnet_k8s.*.id
}

output "get_az_subnet" {
  value = aws_subnet.subnet_k8s.*.availability_zone
}