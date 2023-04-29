# show load balancer dns_name
output "lb_dns_name" {
    value = module.load_balancer.lb_dns_name
}