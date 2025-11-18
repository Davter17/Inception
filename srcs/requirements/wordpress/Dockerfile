# srcs/requirements/wordpress/Dockerfile
FROM debian:bookworm

# Instalar PHP y dependencias necesarias para WordPress
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      php8.2-fpm \
      php8.2-cli \
      php8.2-mysql \
      php8.2-curl \
      php8.2-gd \
      php8.2-mbstring \
      php8.2-xml \
      php8.2-zip \
      curl \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Descargar e instalar WordPress
WORKDIR /var/www/html

# Descargar WP-CLI primero
RUN curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Configuración de PHP-FPM
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Script de inicialización
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
