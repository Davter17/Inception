# srcs/requirements/nginx/Dockerfile
FROM debian:bookworm

# Instalar Nginx y OpenSSL para generar certificados
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      nginx \
      openssl \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copiar configuración personalizada
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Crear directorio para SSL y generar certificados auto-firmados
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/cert.key \
    -out /etc/nginx/ssl/cert.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=student/CN=mpico-bu.42.fr"

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
