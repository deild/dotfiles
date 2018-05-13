NAME := dotfiles
VERSION := $(shell cat VERSION)
# Bump the version in the version file. Set BUMP to [ patch | minor | major ]
BUMP := patch
LATEST_TAG_HASH := $(shell git rev-list --tags --max-count=1)
ifdef LATEST_TAG_HASH
	LATEST_TAG := $(shell git describe --tags $(LATEST_TAG_HASH))
endif
ifdef LATEST_TAG
	REVISION_RANGE := "$(LATEST_TAG)..HEAD"
endif
CHANGELOG := $(shell git log $(REVISION_RANGE) --pretty=format:'%h - %s <br>' --no-merges)

release: ## Bump the version, Commit the version, Push and Publish to GitHub
	@#go get -u github.com/c4milo/github-release
	go get -u github.com/itchio/gothub
	#@go get -u github.com/deild/sembump
	$(eval NEW_VERSION = $(shell sembump -kind $(BUMP) $(VERSION)))
	@echo "Bumping version from $(VERSION) to $(NEW_VERSION)"
	@echo $(NEW_VERSION) > VERSION
	git add VERSION
	git commit -vsam "bump: version to $(NEW_VERSION)"
	git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`
	@echo "Release version $(NEW_VERSION)"
	@#github-release deild/$(NAME) v$(NEW_VERSION) "$$(git rev-parse --abbrev-ref HEAD)" "**Changelog**<br>$(CHANGELOG)" ''
	gothub release \
    --user deild \
    --repo $(NAME) \
    --tag v$(NEW_VERSION) \
    --name "v$(NEW_VERSION)" \
    --description "**Changelog**<br>$(CHANGELOG)"
	git pull --rebase --prune

help: ## Displays the description of each target (Default)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help