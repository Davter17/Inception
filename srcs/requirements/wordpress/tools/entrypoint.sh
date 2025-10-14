#!/bin/bash

# Crear wp-config.php si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$(cat /run/secrets/db_password)" \
        --dbhost="mariadb:3306" \
        --allow-root
fi

# Ejecutar el comando principal
exec "$@"
