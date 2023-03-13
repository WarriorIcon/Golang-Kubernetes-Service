SHELL := /bin/bash

run: 
	go run main.go

build:
	go build -ldflags "-X main.build=local"

# ==============================================================================
# Building containers

# Example: $(shell git rev-parse --short HEAD)
VERSION := 1.0

all: golang-kubernetes-service

golang-kubernetes-service:
	docker build \
		-f zarf/docker/dockerfile \
		-t sales-api:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.
