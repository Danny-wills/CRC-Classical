#cloud-config
package_update: true
package_upgrade: true
runcmd:
- yum update -y
- yum install -y httpd.x86_64
- systemctl enable httpd.service
- systemctl start httpd.service

- yum install -y amazon-efs-utils
- apt-get -y install amazon-efs-utils
- yum install -y nfs-utils
- apt-get -y install nfs-common
- efs_mount_point_1=/var/www/html
- sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/  /var/www/html
- echo ${efs_dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab 
- sudo chmod go+rw /var/www/html
- sudo chown -R $USER:$USER /var/www/html


