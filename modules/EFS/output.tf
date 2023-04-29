# export efs id 
output "efs_id" {
    value = aws_efs_file_system.server_files.id
}
# export efs dns 
output "efs_dns" {
    value = aws_efs_file_system.server_files.dns_name
}