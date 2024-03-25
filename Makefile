.HELP: build-fpc  ## Build Docker image with Free Pascal Compiler
build-fpc:
	docker build -t=fpc -f=docker/fpc.Dockerfile .

.HELP: help  ## Display this message
help:
	@grep -E \
		'^.HELP: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".HELP: |## "}; {printf "\033[36m%-19s\033[0m %s\n", $$2, $$3}'
