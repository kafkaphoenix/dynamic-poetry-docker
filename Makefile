.DEFAULT_GOAL := help

# AutoDoc
# -------------------------------------------------------------------------
.PHONY: help
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

.PHONY: build-docker
build-docker: ## Build docker image
	cd lib && poetry build && cd .. && mv lib/dist src/ && docker build -t test:latest src && rm -r src/dist

.PHONY: run-docker
run-docker: ## Run docker image
	docker run -it test:latest