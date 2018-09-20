BUMP ?= patch #Set BUMP to [ patch | minor | major ]
LATEST_TAG_HASH := $(shell git rev-list --tags --max-count=1)
ifdef LATEST_TAG_HASH
	LATEST_TAG := $(shell git describe --tags $(LATEST_TAG_HASH))
endif
ifdef LATEST_TAG
	REVISION_RANGE := "$(LATEST_TAG)..HEAD"
endif
ifdef LATEST_TAG
	VERSION := $(subst v,,$(LATEST_TAG))
else
	VERSION := 0.0.1
endif

debug: ## Displays debug informations
	@echo "BUMP 		=$(BUMP)"
	@echo "LATEST_TAG_HASH =$(LATEST_TAG_HASH)"
	@echo "LATEST_TAG 	=$(LATEST_TAG)"
	@echo "REVISION_RANGE 	=$(REVISION_RANGE)"
	@echo "VERSION 	=$(VERSION)"
	$(eval CHANGELOG = $(shell git log $(REVISION_RANGE) --pretty=format:'%h - %s <br>' --no-merges))
	@echo "CHANGELOG 	=$(CHANGELOG)"
	$(eval NEW_VERSION = $(shell sembump -kind $(BUMP) $(VERSION)))
	@echo "NEW_VERSION 	=$(NEW_VERSION)"

setup: ## Install dependencies tools
	go get -u github.com/itchio/gothub

release: ## Bump the version, Tag and Publish to GitHub
	$(eval CHANGELOG = $(shell git log $(REVISION_RANGE) --pretty=format:'%h - %s <br>' --no-merges))
	$(eval NEW_VERSION = $(shell sembump -kind $(BUMP) $(VERSION)))
	gothub release \
    --user deild \
    --repo dotfiles \
    --tag v$(NEW_VERSION) \
    --name "v$(NEW_VERSION)" \
    --description "**Changelog**<br>$(CHANGELOG)"
	git pull --rebase --prune

help: ## Displays the description of each target (Default)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help release setup debug
.DEFAULT_GOAL := help