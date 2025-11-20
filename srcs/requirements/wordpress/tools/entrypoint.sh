#!/bin/bash

# Entrypoint script for WordPress Docker container
set -e

# Wait for MariaDB to be ready
sleep 5

# Set default environment variables
if [ ! -f /var/www/html/wp-config.php ]; then
  cd /var/www/html
  
  # Download and set up WordPress
  wp core download --allow-root
  
  # Create wp-config.php with database connection details
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$USER_PASSWORD" \
    --dbhost="mariadb:3306" \
    --allow-root
  
  # Install WordPress with site details
  wp core install \
    --url="https://${LOGIN}.42.fr" \
    --title="Inception" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root
  
  # Create a new WordPress user
  wp user create \
    "$WP_USER" \
    "$WP_USER_EMAIL" \
    --role=author \
    --user_pass="$WP_USER_PASSWORD" \
    --allow-root
fi

# Start PHP-FPM
exec "$@"
