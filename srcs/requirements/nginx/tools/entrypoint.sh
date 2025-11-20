#!/bin/bash
set -e

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate with dynamic domain
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/cert.key \
  -out /etc/nginx/ssl/cert.crt \
  -subj "/CN=${LOGIN}.42.fr"

# Replace server_name in nginx.conf with actual LOGIN
sed -i "s/\${LOGIN}/${LOGIN}/g" /etc/nginx/nginx.conf

# Start nginx
exec nginx -g "daemon off;"
