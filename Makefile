.DEFAULT_GOAL := help
SHELL = /bin/sh

MAKE_PARAMS := $(filter-out $@,$(MAKECMDGOALS))
FILE_PATH := $(word 2,$(MAKE_PARAMS))
CURRENT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: help
help: ## This help menu
	@grep -E '^\S+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Setup local environment
	# init command

.PHONY: lint
lint:   ## Linting & formatting
	# Linting and/or formatting commands

.PHONY: build
build:   ## Build application
	# Compile, transpile, link files, ...

.PHONY: run
run:   ## Run application
	# Run application locally

ONE_TEST :=
ALL_TESTS :=

.PHONY: test
test: ## Run test given test or all tests
ifdef FILE_PATH
	@$(ONE_TEST)
else
	@$(ALL_TESTS)
endif

.PHONY: test-watch
test-watch: ## Run given test or all tests in watch mode
ifdef FILE_PATH
	- @$(ONE_TEST)
	@while true; do \
		inotifywait -qq -r -e create,modify,move,delete ./; \
		printf "\n[ . . . Re-running tests . . . ]\n"; \
		$(ONE_TEST); \
	done
else
	- @$(ALL_TESTS)
	@while true; do \
		inotifywait -qq -r -e create,modify,move,delete ./; \
		printf "\n[ . . . Re-running tests . . . ]\n"; \
		$(ALL_TESTS); \
	done
endif
