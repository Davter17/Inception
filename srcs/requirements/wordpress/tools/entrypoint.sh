#!/bin/bash

# Esperar a que MariaDB esté lista
sleep 5

# Descargar WordPress si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Descargando WordPress..."
    wp core download --allow-root --path=/var/www/html
    
    echo "Creando wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$USER_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root \
        --path=/var/www/html
    
    echo "Instalando WordPress..."
    wp core install \
        --url="https://mpico-bu.42.fr" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root \
        --path=/var/www/html
    
    echo "Creando usuario adicional..."
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root \
        --path=/var/www/html
fi

# Ejecutar el comando principal
exec "$@"
