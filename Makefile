NAME := dotfiles
VERSION := $(shell cat VERSION)
# Bump the version in the version file. Set BUMP to [ patch | minor | major ]
BUMP := minor
PRE := 
LATEST_TAG_HASH := $(shell git rev-list --tags --max-count=1)
ifdef LATEST_TAG_HASH
	LATEST_TAG := $(shell git describe --tags $(LATEST_TAG_HASH))
endif
ifdef LATEST_TAG
	REVISION_RANGE := "$(LATEST_TAG)..HEAD"
endif
CHANGELOG := $(shell git log $(REVISION_RANGE) --pretty=format:'%h - %s' --no-merges)

release: 
	@go get -u github.com/c4milo/github-release
	#@go get -u github.com/deild/sembump
	$(eval NEW_VERSION = $(shell sembump -kind $(BUMP) $(VERSION)))
	@echo "Bumping version from $(VERSION) to $(NEW_VERSION)"
	@echo $(NEW_VERSION) > VERSION
	#@echo "Updating links to download binaries in README.md"
	#sed -i s/$(VERSION)/$(NEW_VERSION)/g README.md
	git add VERSION README.md
	#git commit -vsam "Bump version to $(NEW_VERSION)"
	@echo "Release new version $(NEW_VERSION)"

	#github-release deild/$(NAME) $(VERSION) "$$(git rev-parse --abbrev-ref HEAD)" "**Changelog**<br/>$(CHANGELOG)" ''
	git pull