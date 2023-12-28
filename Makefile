SHELL = /usr/bin/env bash -euo pipefail -c

BIN_NAME = ping-app

ARCH     = amd64
OS       = $(shell uname | tr [[:upper:]] [[:lower:]])
PLATFORM = $(OS)/$(ARCH)
DIST     = dist/$(PLATFORM)
BIN      = $(DIST)/$(BIN_NAME)

BIN_NAME ?= ping-app

dist:
	mkdir -p $(DIST)

dev: dist
	GOARCH=$(ARCH) GOOS=$(OS) go build -ldflags "$(LD_FLAGS)" -o $(BIN)
.PHONY: dev

BUILD_ARGS = BIN_NAME=consul-ecs
TAG        = $(BIN_NAME)/$(TARGET):latest
BA_FLAGS   = $(addprefix --build-arg=,$(BUILD_ARGS))
FLAGS      = --target $(TARGET) --platform $(PLATFORM) --tag $(TAG) $(BA_FLAGS)

docker: OS = linux
docker: ARCH = amd64
docker: TARGET = release-default
docker: dev
	export DOCKER_BUILDKIT=1; docker build $(FLAGS) .
.PHONY: docker