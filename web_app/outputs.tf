output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.web_asg.id
}

output "load_balancer_dns_name" {
  value = aws_lb.web_lb.dns_name
}