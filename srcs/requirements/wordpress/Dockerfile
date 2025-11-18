# Use Debian Bookworm as the base image
FROM debian:bookworm

# Install PHP and required extensions, along with curl and WP-CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      php8.2-fpm \
      php8.2-mysql \
      php8.2-curl \
      php8.2-gd \
      php8.2-mbstring \
      php8.2-xml \
      curl \
      ca-certificates && \
    curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    rm -rf /var/lib/apt/lists/*

# Copy custom PHP-FPM configuration and entrypoint script into the container
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the default command to run PHP-FPM
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
