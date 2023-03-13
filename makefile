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

# ==============================================================================
# Running from within k8s/kind

KIND_CLUSTER := ardan-starter-cluster

kind-up:
	kind create cluster \
		--image kindest/node:v1.25.3@sha256:f52781bc0d7a19fb6c405c2af83abfeb311f130707a0e219175677e366cc45d1 \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-load:
		kind load docker-image sales-api:$(VERSION) --name $(KIND_CLUSTER)

kind-apply:
	cat zarf/k8s/base/service-pod/base-service.yaml | kubectl apply -f -

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide 
	kubectl get pods -o wide --watch --all-namespaces

kind-logs:
		kubectl logs -l app=service --all-containers=true -f --tail=100 --namespace=service-system
