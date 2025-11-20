# Makefile (at root)

NAME=inception
COMPOSE_FILE=srcs/docker-compose.yml
ENV_FILE=srcs/.env

# Read LOGIN from .env to create host paths
LOGIN := $(shell grep '^LOGIN=' $(ENV_FILE) | cut -d'=' -f2)

HOST_MARIADB_DIR := /home/$(LOGIN)/data/mariadb
HOST_WORDPRESS_DIR := /home/$(LOGIN)/data/wordpress

# Build and manage the Inception project with Docker Compose
all: up 

# Create necessary data directories
dirs:
	@mkdir -p $(HOST_MARIADB_DIR) $(HOST_WORDPRESS_DIR)
	@echo "Data paths ready: $(HOST_MARIADB_DIR), $(HOST_WORDPRESS_DIR)"

# Build Docker images for the project
build: dirs
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) build

# Start the containers in detached mode
up: build
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) up -d

# Stop the containers
down:
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) down

# Stop and remove containers
clean: down
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) rm -f

# Remove data directories (use with caution)
fclean: clean
	@sudo rm -rf $(HOST_MARIADB_DIR) $(HOST_WORDPRESS_DIR)

# Rebuild everything from scratch
re: fclean up

.PHONY: all dirs build up down clean fclean re