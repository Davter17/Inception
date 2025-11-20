#!/bin/bash

# Entrypoint script for MariaDB Docker container
set -eo pipefail

# Set default environment variables
MYSQL_ROOT_PASSWORD="${ROOT_PASSWORD}"
MYSQL_PASSWORD="${USER_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE:-wordpress}"
MYSQL_USER="${MYSQL_USER:-wp_user}"

# Check for required passwords
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: Passwords not set"
  exit 1
fi

# Prepare MariaDB directories
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize the database if it doesn't exist or is empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
  
  # Initialize MariaDB data directory
  mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal >/dev/null
  
  # Start temporary MariaDB server
  mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
  pid="$!"
  
  # Wait for the server to be ready
  for i in {1..40}; do
    mariadb-admin --protocol=socket --socket=/run/mysqld/mysqld.sock ping --silent && break
    sleep 0.5
  done
  
  # Configure root user and create database/user
  mysql --protocol=socket --socket=/run/mysqld/mysqld.sock <<-SQL
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;
  CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
  FLUSH PRIVILEGES;
SQL
  
  # Shutdown temporary server
  mariadb-admin --protocol=socket --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
  wait "$pid"
fi

# Start the MariaDB server
exec "$@"
