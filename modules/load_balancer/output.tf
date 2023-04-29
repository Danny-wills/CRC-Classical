# export load balancer dns name
output "lb_dns_name" {
    value = aws_lb.server_lb.dns_name
}
# export target group name
output "target_group_arn" {
    value = aws_lb_target_group.target.arn
}
