.DEFAULT_GOAL       := help

ARGS                 = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
MAKEFLAGS           += --silent

CURRENT_DIRECTORY   := $(shell pwd)

MAKE                 = make
COMPOSER             = composer

##
## ----------------------------------------------------------------------------
##   QA
## ----------------------------------------------------------------------------
##
.PHONY: qa-all
qa-all: ## Database full init
	$(MAKE) qa-composer-validate qa-php-cs qa-phpstan qa-security qa-phpunit

.PHONY: qa-composer-validate
qa-composer-validate: ## Check composer.json format
	$(COMPOSER) validate --no-check-lock

.PHONY: qa-php-cs
qa-php-cs: ## Check formatting of PHP files
	./vendor/bin/php-cs-fixer fix --dry-run --config=.php-cs-fixer.dist.php

.PHONY: qa-phpstan
qa-phpstan: ## Run PHPStan
	./vendor/bin/phpstan analyse --memory-limit 2G

.PHONY: qa-security
qa-security: ## Run a security analysis on dependencies
	./vendor/bin/local-php-security-checker-installer && ./vendor/bin/local-php-security-checker

.PHONY: qa-phpunit
qa-phpunit: ## Run the tests suit (unit & functional)
	./vendor/bin/phpunit --stop-on-failure

##
## ----------------------------------------------------------------------------
##   DOCKER
## ----------------------------------------------------------------------------
##

.PHONY: docker-test
docker-test: ## Run docker-compose for test environment
	docker-compose --env-file .env.test -f docker-compose.test.yml up --remove-orphans -d

##
## ----------------------------------------------------------------------------
##   DATABASE
## ----------------------------------------------------------------------------
##

.PHONY: db-init
db-init: ## Database full init
	$(MAKE) db-drop db-create db-fixtures

.PHONY: db-drop
db-drop: ## Drop database
	php bin/doctrine orm:schema-tool:drop --force

.PHONY: db-create
db-create: ## Create database
	php bin/doctrine orm:schema-tool:create

.PHONY: db-fixtures
db-fixtures: ## Load fixtures
	php bin/fixtures

##
## ----------------------------------------------------------------------------
##   Misc
## ----------------------------------------------------------------------------
##

.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'

.DEFAULT:
	@:
