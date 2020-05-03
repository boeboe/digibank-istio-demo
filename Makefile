# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS

build: ## Build all the containers
		cd accounts && $(MAKE) build
		cd authentication && $(MAKE) build
		cd bills && $(MAKE) build
		cd portal && $(MAKE) build
		cd support && $(MAKE) build
		cd transactions && $(MAKE) build
		cd userbase && $(MAKE) build

build-nc: ## Build all the containers without caching
		cd accounts && $(MAKE) build-nc
		cd authentication && $(MAKE) build-nc
		cd bills && $(MAKE) build-nc
		cd portal && $(MAKE) build-nc
		cd support && $(MAKE) build-nc
		cd transactions && $(MAKE) build-nc
		cd userbase && $(MAKE) build-nc

release: build-nc publish ## Make a release by building and publishing all `{version}` and `latest` tagged containers
		cd accounts && $(MAKE) release
		cd authentication && $(MAKE) release
		cd bills && $(MAKE) release
		cd portal && $(MAKE) release
		cd support && $(MAKE) release
		cd transactions && $(MAKE) release
		cd userbase && $(MAKE) release

publish: publish-latest publish-version ## Publish all `{version}` and `latest` tagged containers
		cd accounts && $(MAKE) publish
		cd authentication && $(MAKE) publish
		cd bills && $(MAKE) publish
		cd portal && $(MAKE) publish
		cd support && $(MAKE) publish
		cd transactions && $(MAKE) publish
		cd userbase && $(MAKE) publish

publish-latest: tag-latest ## Publish all `latest` tagged container
		cd accounts && $(MAKE) publish-latest
		cd authentication && $(MAKE) publish-latest
		cd bills && $(MAKE) publish-latest
		cd portal && $(MAKE) publish-latest
		cd support && $(MAKE) publish-latest
		cd transactions && $(MAKE) publish-latest
		cd userbase && $(MAKE) publish-latest

publish-version: tag-version ## Publish all `{version}` tagged containers
		cd accounts && $(MAKE) publish-version
		cd authentication && $(MAKE) publish-version
		cd bills && $(MAKE) publish-version
		cd portal && $(MAKE) publish-version
		cd support && $(MAKE) publish-version
		cd transactions && $(MAKE) publish-version
		cd userbase && $(MAKE) publish-version

tag: tag-latest tag-version ## Generate all container tags for the `{version}` ans `latest` tags
		cd accounts && $(MAKE) tag
		cd authentication && $(MAKE) tag
		cd bills && $(MAKE) tag
		cd portal && $(MAKE) tag
		cd support && $(MAKE) tag
		cd transactions && $(MAKE) tag
		cd userbase && $(MAKE) tag

tag-latest: ## Generate all containers `{version}` tag
		cd accounts && $(MAKE) tag-latest
		cd authentication && $(MAKE) tag-latest
		cd bills && $(MAKE) tag-latest
		cd portal && $(MAKE) tag-latest
		cd support && $(MAKE) tag-latest
		cd transactions && $(MAKE) tag-latest
		cd userbase && $(MAKE) tag-latest

tag-version: ## Generate all containers `latest` tag
		cd accounts && $(MAKE) tag-version
		cd authentication && $(MAKE) tag-version
		cd bills && $(MAKE) tag-version
		cd portal && $(MAKE) tag-version
		cd support && $(MAKE) tag-version
		cd transactions && $(MAKE) tag-version
		cd userbase && $(MAKE) tag-version

stop: ## Stop and remove all running container
		cd accounts && $(MAKE) stop 2>/dev/null || true
		cd authentication && $(MAKE) stop 2>/dev/null || true
		cd bills && $(MAKE) stop 2>/dev/null || true
		cd portal && $(MAKE) stop 2>/dev/null || true
		cd support && $(MAKE) stop 2>/dev/null || true
		cd transactions && $(MAKE) stop 2>/dev/null || true
		cd userbase && $(MAKE) stop 2>/dev/null || true
		docker stop mongo 2>/dev/null ; docker rm mongo 2>/dev/null || true
