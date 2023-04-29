# create security group for bastion host
resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion_host_sg"
  description = "Allow http/s inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http internet traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
		cidr_blocks 		 = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http internet traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
		cidr_blocks 		 = ["0.0.0.0/0"]
  }
  ingress {
    description      = "https internet traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
		cidr_blocks 		 = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-SG"
  }
}
# create security group for load balancer
resource "aws_security_group" "lb_sg" {
  name        = "load_balancer_sg"
  description = "Allow http/s inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http internet traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
		cidr_blocks 		 = ["0.0.0.0/0"]
  }
  ingress {
    description      = "https internet traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
		cidr_blocks 		 = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load-balancer-SG"
  }
}
# create security group for private instances
resource "aws_security_group" "private_instances" {
  name        = "private_instances_sg"
  description = "Allow http inbound traffic from load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "load_balancer_traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
		security_groups  = [aws_security_group.lb_sg.id] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

	depends_on = [
		aws_security_group.lb_sg
	]

  tags = {
    Name = "private-instances-SG"
  }
}
# create security group for efs
resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow nfs inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "nfs from bastion host and private instance"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_host_sg.id, aws_security_group.private_instances.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-SG"
  }
}
# add outbound rule from load balancer to private instance
resource "aws_security_group_rule" "lb2pi" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
	source_security_group_id = "${aws_security_group.private_instances.id}"
  security_group_id = aws_security_group.lb_sg.id

	depends_on = [
		aws_security_group.private_instances
	]
}
# add outbound rule from private instance to efs
resource "aws_security_group_rule" "pi2efs" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
	source_security_group_id		= "${aws_security_group.efs_sg.id}"
  security_group_id = aws_security_group.private_instances.id

	depends_on = [
		aws_security_group.efs_sg
	]
}
# add outbound rule from bastion host to efs
resource "aws_security_group_rule" "bh2efs" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
	source_security_group_id		= "${aws_security_group.efs_sg.id}"
  security_group_id = aws_security_group.bastion_host_sg.id

	depends_on = [
		aws_security_group.efs_sg
	]
}

