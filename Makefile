BASE_DIR := $(shell realpath .)
STACK_INSTALL := $(shell stack --docker --no-docker-set-user path --local-install-root)
BUILD_DIR := $(BASE_DIR)/.build
LAMBDA_FUNCTION := azupdate

ENV_FILE=$(BASE_DIR)/.env
ifeq (,$(wildcard $(ENV_FILE)))
$(error ".env file not found")
endif
include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))
DOCKER_ENV_ARGS := $(shell while read line; do echo --docker-env="'"$$line"'"; done < $(ENV_FILE))

test_env_vars:
	@test -n "$$APP_ENV" || (echo "Missing APP_ENV" && exit 1)

watch:
	@ghcid --command="stack ghci"

build: test_env_vars
	@echo Deleting old function
	@rm -rf .build
	@echo Checking haskell code
	@hlint .
	@find . -path ./.stack-work -prune -o -type f -name "*.hs" \! -regex "^\.stack" -exec hindent --validate {} \;
	@echo Building function code
	@stack build --docker --no-docker-set-user $(DOCKER_ENV_ARGS) --verbosity info
	@mkdir -p $(BUILD_DIR)/$(LAMBDA_FUNCTION)/config
	@cp $(STACK_INSTALL)/bin/$(LAMBDA_FUNCTION) $(BUILD_DIR)/$(LAMBDA_FUNCTION)/bootstrap
	@cp config/*.dhall $(BUILD_DIR)/$(LAMBDA_FUNCTION)/config
	@cd $(BUILD_DIR)/$(LAMBDA_FUNCTION) && zip -q ../$(LAMBDA_FUNCTION).zip config/*.dhall bootstrap

format:
	@find . -path ./.stack-work -prune -o -type f -name "*.hs" \! -regex "^\.stack" -exec hindent {} \;

clean:
	@stack clean

repl:
	@stack repl