# create user data file
data "template_file" "user_data" {
    template = file("user_data.sh")
    vars = {
      efs_dns_name = var.efs_dns_name
    }
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }
}

# create ec2 instance for bastion host
resource "aws_instance" "bastion_host" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet1_id
  vpc_security_group_ids = [var.bastion_host_sg_id]
  key_name               = "Server_key"
  user_data              = data.template_cloudinit_config.config.rendered

  tags = {
    Name = "Bastion Host"
  }

  depends_on = [
    var.efs_id
  ]
}