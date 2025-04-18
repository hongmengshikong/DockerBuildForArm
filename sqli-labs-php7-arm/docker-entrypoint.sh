#!/bin/bash
set -e

# 启动 MariaDB
service mariadb start

# 等待数据库就绪
while ! mysqladmin ping -h 127.0.0.1 --silent; do
    sleep 1
done

# 设置 root 密码为 123456，并允许远程连接（可选）
mysql -u root -e "
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
CREATE DATABASE IF NOT EXISTS security;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

# 修改 sqli-labs 的数据库配置（/var/www/html/sql-connections/db-creds.inc）
sed -i "s/\$host = 'localhost';/\$host = '127.0.0.1';/g" /var/www/html/sql-connections/db-creds.inc
sed -i "s/\$dbpass ='';/\$dbpass ='123456';/g" /var/www/html/sql-connections/db-creds.inc

# 启动 Apache
exec apache2-foreground
