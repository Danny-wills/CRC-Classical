# create launch template 
resource "aws_launch_template" "server_efs_temp" {
  name      = "server_efs"
  image_id  = var.image_id
  instance_type = var.instance_type
  key_name = "Server_key"
  user_data = "${base64encode(var.user_data)}"

  network_interfaces {
    security_groups = [var.private_instance_sg]
  }

  tags = {
    name = "server"
  }
}
# create autoscaling group
resource "aws_autoscaling_group" "ASG" {
    name    = "${var.project_name}-ASG"
    min_size    = 2
    desired_capacity = 2
    max_size    = 3
    health_check_grace_period = 300
    health_check_type = "ELB"
    launch_template {
      id = aws_launch_template.server_efs_temp.id
      version = "$Latest"
    }
    vpc_zone_identifier = [var.private_subnet1_id, var.private_subnet2_id]
    target_group_arns = [var.target_group_arn]
}