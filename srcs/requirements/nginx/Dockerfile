#Use Debian Bookworm as the base image
FROM debian:bookworm

# Update package lists and install nginx and openssl
RUN apt-get update && \ 
    apt-get install -y --no-install-recommends nginx openssl && \ 
    rm -rf /var/lib/apt/lists/*	

# Copy custom nginx configuration file into the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose ports 443, only info about HTTPS
EXPOSE 443

# Set nginx to run in the foreground when the container starts
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
