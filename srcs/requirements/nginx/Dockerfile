#Use Debian Bookworm as the base image
FROM debian:bookworm

# Update package lists and install nginx and openssl
RUN apt-get update && \ 
    apt-get install -y --no-install-recommends nginx openssl && \ 
    rm -rf /var/lib/apt/lists/*	

# Copy custom nginx configuration file into the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Generate self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \ 
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \ 
    -keyout /etc/nginx/ssl/cert.key \ 
    -out /etc/nginx/ssl/cert.crt \ 
    -subj "/CN=mpico-bu.42.fr"

# Expose ports 443, only info about HTTPS
EXPOSE 443

# Set nginx to run in the foreground when the container starts
ENTRYPOINT ["nginx", "-g", "daemon off;"]
