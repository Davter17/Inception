# Makefile (en el root)

NAME=inception
COMPOSE_FILE=srcs/docker-compose.yml
ENV_FILE=srcs/.env

# Lee LOGIN desde .env para crear rutas en el host
LOGIN := $(shell grep '^LOGIN=' $(ENV_FILE) | cut -d'=' -f2)

HOST_MARIADB_DIR := /home/$(LOGIN)/data/mariadb
HOST_WORDPRESS_DIR := /home/$(LOGIN)/data/wordpress

all: up

dirs:
	@mkdir -p $(HOST_MARIADB_DIR) $(HOST_WORDPRESS_DIR)
	@echo "Rutas de datos listas: $(HOST_MARIADB_DIR), $(HOST_WORDPRESS_DIR)"

secrets:
	@test -s secrets/db_root_password.txt || (echo "PON_AQUI_ROOT_PASSWORD" > secrets/db_root_password.txt && echo "=> Rellena secrets/db_root_password.txt")
	@test -s secrets/db_password.txt || (echo "PON_AQUI_USER_PASSWORD" > secrets/db_password.txt && echo "=> Rellena secrets/db_password.txt")

build: dirs
	@docker compose -f $(COMPOSE_FILE) --project-name $(NAME) build

up: secrets build
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

re: fclean all
