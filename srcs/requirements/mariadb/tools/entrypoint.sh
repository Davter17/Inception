#!/usr/bin/env bash
# srcs/requirements/mariadb/tools/entrypoint.sh
set -euo pipefail

# Usar variables de entorno directamente
MYSQL_ROOT_PASSWORD="${ROOT_PASSWORD}"
MYSQL_PASSWORD="${USER_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE:-wordpress}"
MYSQL_USER="${MYSQL_USER:-wp_user}"

if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: ROOT_PASSWORD o USER_PASSWORD no están definidas"
  exit 1
fi

# Asegurar sockets/dirs
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Si no está inicializado, lo hacemos
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Inicializando datadir..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal >/dev/null

  # Arranque temporal en segundo plano para ejecutar SQL de bootstrap
  mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock --pid-file=/run/mysqld/mysqld.pid &
  pid="$!"

  # Esperar a que responda
  for i in {1..40}; do
    if mariadb-admin --protocol=socket --socket=/run/mysqld/mysqld.sock ping --silent; then
      break
    fi
    sleep 0.5
  done

  # Bootstrap: root pw, base y usuario app
  mysql --protocol=socket --socket=/run/mysqld/mysqld.sock <<-SQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
SQL

  # Apagar el mysqld temporal limpiamente
  mariadb-admin --protocol=socket --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
  wait "$pid"
fi

# Ejecutar servidor real como PID 1
exec "$@"
