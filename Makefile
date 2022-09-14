.DEFAULT_GOAL := init

# DEFAULTS
# ###############
SOURCES_DIR := src
ENTRYPOINT := extension.yaml
TOKEN_LOCATION := ./secrets/token
TENANT_LOCATION := ./secrets/tenant
DOCKER_PORT := 161

# Derivatives
# ###############
RETREIVE_API_TOKEN := $$(cat $(TOKEN_LOCATION))
RETREIVE_TENANT := $$(cat $(TENANT_LOCATION))
SOURCES := $(shell find ./$(SOURCES_DIR)/ ! -type d)
_ENTRYPOINT := $(SOURCES_DIR)/$(ENTRYPOINT)


# ===== please do not remove this =====
# sources are at: https://github.com/dynatrace-extensions/toolz/blob/main/common.mk
include $(shell which __dt_ext_common_make)
include $(shell test -n "$$DT_EXTENSION_TOOLING_LOC" && echo "$$DT_EXTENSION_TOOLING_LOC/common.mk" || echo "")
# ===== please do not remove this =====

# Bootstrap
# ###############
.PHONY: init clean really_clean 
init: ## one time setup
	@# this is used to squash the "direnv is blocked" prompt which misguides the first time users, it's silenced to not show the error message if the clobber fails
	@-mv --no-clobber _.envrc .envrc 2>/dev/null
	direnv allow .

# Utility hooks
# ###############
clean: gitclean ## remove artifacts
	rm -f extension.zip extension.zip.sig bundle.zip

really_clean: gitclean-with-libs ## remove EVERYTHING
