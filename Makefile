DOCKER_SWAGGER_CLI=fewlines/swagger-cli
DOCKER_COMMAND := docker

DOCKER_SWAGGER_CLI_NODE_VERSION=14.15.3-alpine
DOCKER_SWAGGER_CLI_PACKAGE_VERSION=4.0.4

GIT_BIN := git

ifdef GIT_BIN
GIT_OBJECT := HEAD
GIT_BRANCH := $$($(GIT_BIN) describe --all)
GIT_REPOSITORY := https://github.com/$(shell $(GIT_BIN) remote get-url origin | sed -e 's/.*://' -e 's/\\.git//')
GIT_SHA := $(shell $(GIT_BIN) rev-parse $(GIT_OBJECT))
GIT_SHORT_SHA := $(shell $(GIT_BIN) rev-parse --short $(GIT_OBJECT))
APP_RELEASE_NAME := $(shell basename $(GIT_BRANCH) | sed 's/^\(CU-[[:alnum:]]*\).*/\1/')
endif


build-image: SwaggerCLI.Dockerfile
	git describe --all
	echo $(APP_RELEASE_NAME)
	$(DOCKER_COMMAND) build \
		--build-arg NODE_VERSION=node:$(DOCKER_SWAGGER_CLI_NODE_VERSION) \
		--build-arg SWAGGER_CLI_VERSION=$(DOCKER_SWAGGER_CLI_PACKAGE_VERSION) \
		--file SwaggerCLI.Dockerfile \
		--tag $(DOCKER_SWAGGER_CLI):$(APP_RELEASE_NAME)-$(GIT_SHORT_SHA) \
		--tag $(DOCKER_SWAGGER_CLI):$(APP_RELEASE_NAME)-latest \
		.

publish-image:
	$(DOCKER_COMMAND) push $(DOCKER_SWAGGER_CLI):$(APP_RELEASE_NAME)-$(GIT_SHORT_SHA)
	$(DOCKER_COMMAND) push $(DOCKER_SWAGGER_CLI):$(APP_RELEASE_NAME)-latest