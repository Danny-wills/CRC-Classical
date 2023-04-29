# create efs
resource "aws_efs_file_system" "server_files" {
  creation_token = "Server files"
  encrypted      = true

  tags = {
    Name = "Server files"
  }
}

# efs backup
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.server_files.id

  backup_policy {
    status = "ENABLED"
  }
}

# create mount target1
resource "aws_efs_mount_target" "target_subnet1" {
  file_system_id  = aws_efs_file_system.server_files.id
  subnet_id       = var.private_subnet1_id
  security_groups = [var.efs_sg_id] 
}
# create mount target2
resource "aws_efs_mount_target" "target_subnet2" {
  file_system_id  = aws_efs_file_system.server_files.id
  subnet_id       = var.private_subnet2_id
  security_groups = [var.efs_sg_id] 
}
