#!/bin/bash
yum update -y
yum install -y httpd
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
MAC=$(curl http://169.254.169.254/latest/meta-data/mac)
echo "<html><body><h1>Instance ID: ${INSTANCE_ID}</h1><h2>IP Address: ${LOCAL_IP}</h2><h3>MAC Address: ${MAC}</h3></body></html>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd