#!/bin/bash
set -e

echo "Setting root password and database permissions..."

# 设置 MariaDB root 密码和权限
mysql -u root -e "
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
CREATE DATABASE IF NOT EXISTS security;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

# 修改 sqli-labs 的数据库配置（/var/www/html/sql-connections/db-creds.inc）
sed -i "s/\$dbpass ='';/\$dbpass ='123456';/g" /var/www/html/sql-connections/db-creds.inc
sed -i "s/\$host = 'localhost';/\$host = '127.0.0.1';/g" /var/www/html/sql-connections/db-creds.inc

echo "Database initialized successfully."

