APP_NAME=digibank-authentication-svc
DOCKER_ACCOUNT=boeboe
PORT=3200
MONGO_IMAGE=mvertes/alpine-mongo
VERSION=1.0.0

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS

build: ## Build the container
	docker build -t $(DOCKER_ACCOUNT)/$(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(DOCKER_ACCOUNT)/$(APP_NAME) .

network: ## Create local docker network
	docker network ls|grep mynet > /dev/null || docker network create --driver bridge mynet

run: network ## Run container
	docker run -i -t --rm -p=$(PORT):$(PORT) --name="$(APP_NAME)" --net mynet --env-file env.list $(DOCKER_ACCOUNT)/$(APP_NAME)

sh: network ## Run interactive shell in container
	docker run -i -t --entrypoint /bin/sh --name="$(APP_NAME)" --net mynet --env-file env.list $(DOCKER_ACCOUNT)/$(APP_NAME)

mongo: ## Run mongo DB container
	docker run -d --name mongo --net mynet -p 27017:27017 ${MONGO_IMAGE}

up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers

publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers

publish-latest: tag-latest ## Publish the `latest` tagged container
	@echo 'publish latest to $(DOCKER_ACCOUNT)/$(APP_NAME)'
	docker push $(DOCKER_ACCOUNT)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` tagged container
	@echo 'publish $(VERSION) to $(DOCKER_ACCOUNT)/$(APP_NAME)'
	docker push $(DOCKER_ACCOUNT)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(DOCKER_ACCOUNT)/$(APP_NAME) $(DOCKER_ACCOUNT)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(DOCKER_ACCOUNT)/$(APP_NAME) $(DOCKER_ACCOUNT)/$(APP_NAME):$(VERSION)
