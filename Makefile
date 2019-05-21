PROJECT_NAME ?= todobackend
ORG_NAME ?= deepak89
REPO_NAME ?= todobackend

# FILENAMES
DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
REL_COMPOSE_FILE := docker/release/docker-compose.yml

REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
DEV_PROJECT := $(REL_PROJECT)DEV


.Phony: test build release clean

test:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build 
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up test

build:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder

release:
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE)  build
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up agent
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py collectstatic
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py migrate --noinput
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up test

clean:
	docker-compose  -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	docker-compose  -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f
	docker-compose  -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) kill
	docker-compose  -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) rm -f