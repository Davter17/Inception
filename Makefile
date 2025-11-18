# Makefile (at root)

NAME=inception
COMPOSE_FILE=srcs/docker-compose.yml
ENV_FILE=srcs/.env

# Read LOGIN from .env to create host paths
LOGIN := $(shell grep '^LOGIN=' $(ENV_FILE) | cut -d'=' -f2)

HOST_MARIADB_DIR := /home/$(LOGIN)/data/mariadb
HOST_WORDPRESS_DIR := /home/$(LOGIN)/data/wordpress

all: up

dirs:
	@mkdir -p $(HOST_MARIADB_DIR) $(HOST_WORDPRESS_DIR)
	@echo "Data paths ready: $(HOST_MARIADB_DIR), $(HOST_WORDPRESS_DIR)"

build: dirs
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) build

up: build
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) up -d

down:
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) down

logs:
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) logs -f --tail=100

ps:
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) ps

clean: down
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) rm -f

fclean: clean
	@sudo rm -rf $(HOST_MARIADB_DIR) $(HOST_WORDPRESS_DIR)

re: fclean up

.PHONY: all dirs build up down logs ps clean fclean re