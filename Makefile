SOURCES_DIR := src
ENTRYPOINT := extension.yaml
TOKEN_LOCATION := ./secrets/token
TENANT_LOCATION := ./secrets/tenant
DOCKER_PORT := 161

RETREIVE_API_TOKEN := $$(cat $(TOKEN_LOCATION))
RETREIVE_TENANT := $$(cat $(TENANT_LOCATION))
SOURCES := $(shell find ./$(SOURCES_DIR)/ ! -type d)
_ENTRYPOINT := $(SOURCES_DIR)/$(ENTRYPOINT)

# ===== please do not remove this =====
# sources are at: https://github.com/dynatrace-extensions/toolz/blob/main/common.mk
include $(shell which __dt_ext_common_make)
include $(shell test -n "$$DT_EXTENSION_TOOLING_LOC" && echo "$$DT_EXTENSION_TOOLING_LOC/common.mk" || echo "")
# ===== please do not remove this =====

# Porcelain
# ###############
.PHONY: test

test: ## run all tests
	@echo "Not implemented"; false

# Bootstrap
# ###############
.PHONY: init clean really_clean 
init: ## one time setup
	direnv allow .

# Utility hooks
# ###############
clean: gitclean ## remove artifacts
	rm -f extension.zip extension.zip.sig bundle.zip

really_clean: gitclean-with-libs ## remove EVERYTHING
