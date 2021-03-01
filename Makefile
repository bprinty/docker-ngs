# ~
#
# Makefile for managing development/deployment
#
# ------------------------------------------------------


# config
# -----
IMAGE       = bprinty/ngs
PROJECT     = docker-ngs
BRANCH      = `git branch | grep '*' | awk '{print ":"$$2}' | grep -v 'main' | grep -v 'HEAD'`
VERSION     = 0.0.1


# targets
# -------
.PHONY: help docs info clean init build

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


info: ## list info about package
	@echo "$(PROJECT), version $(VERSION)$(BRANCH)"
	@echo last updated: `git log | grep --color=never 'Date:' | head -1 | sed 's/Date:   //g'`


clean: ## clean unnecessary files from repository
	rm -rf *.retry
	rm -rf .vagrant


image: ## build and tag image
	docker build -t $(IMAGE):latest .
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)


push: ## push image to docker hub
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(VERSION)

