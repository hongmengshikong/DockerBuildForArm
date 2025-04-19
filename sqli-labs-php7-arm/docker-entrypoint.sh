#!/bin/bash
set -e

# 启动 MariaDB
echo "Starting MariaDB..."
service mariadb start
sleep 5  # 稍微等待一下，确保 MariaDB 完全启动

# 检查 MariaDB 是否成功启动
if ! mysqladmin ping -h 127.0.0.1 --silent; then
    echo "MariaDB failed to start"
    exit 1
fi

# 等待数据库就绪
until mysqladmin ping -h 127.0.0.1 --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done

# 检查是否已经执行过数据库初始化
if [ ! -f /var/www/html/init_done.flag ]; then
    # 如果没有执行过，执行初始化数据库的脚本
    echo "Initializing database..."
    /usr/local/bin/init-db.sh

    # 创建标识文件，表示初始化已经完成
    touch /var/www/html/init_done.flag
else
    echo "Database already initialized, skipping initialization."
fi

# 启动 Apache
echo "Starting Apache..."
exec apache2-foreground

