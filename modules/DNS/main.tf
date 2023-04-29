# get hosted zone
data "aws_route53_zone" "my_zone" {
  name         = "ojowilliamsdaniel.online"
  private_zone = true
}

# create alias record for load balancer
resource "aws_route53_record" "lb" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "lb.${aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}