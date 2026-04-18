# Makefile for homebox
# Provides common development and build tasks

.PHONY: all build test lint clean dev docker-build docker-run help

# Variables
APP_NAME := homebox
BIN_DIR := bin
BACKEND_DIR := backend
FRONTEND_DIR := frontend
DOCKER_IMAGE := homebox
DOCKER_TAG := latest

# Go variables
GO := go
GOFLAGS := -v
LDFLAGS := -ldflags "-s -w"

all: build

## build: Build the backend binary
build:
	@echo "Building $(APP_NAME)..."
	@mkdir -p $(BIN_DIR)
	cd $(BACKEND_DIR) && $(GO) build $(GOFLAGS) $(LDFLAGS) -o ../$(BIN_DIR)/$(APP_NAME) ./app/api

## test: Run all backend tests
test:
	@echo "Running tests..."
	cd $(BACKEND_DIR) && $(GO) test ./... -cover -race

## test-ci: Run tests with output suitable for CI
test-ci:
	@echo "Running tests (CI mode)..."
	cd $(BACKEND_DIR) && $(GO) test ./... -coverprofile=coverage.out -race

## lint: Run linters
lint:
	@echo "Running linters..."
	cd $(BACKEND_DIR) && golangci-lint run ./...

## fmt: Format Go source code
fmt:
	@echo "Formatting code..."
	cd $(BACKEND_DIR) && $(GO) fmt ./...

## vet: Run go vet
vet:
	@echo "Running go vet..."
	cd $(BACKEND_DIR) && $(GO) vet ./...

## dev: Run the backend in development mode with live reload
dev:
	@echo "Starting development server..."
	cd $(BACKEND_DIR) && air

## generate: Run go generate for all packages
generate:
	@echo "Running go generate..."
	cd $(BACKEND_DIR) && $(GO) generate ./...

## docker-build: Build the Docker image
docker-build:
	@echo "Building Docker image $(DOCKER_IMAGE):$(DOCKER_TAG)..."
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

## docker-run: Run the application in Docker
docker-run:
	@echo "Running Docker container..."
	docker run -p 7745:7745 --rm $(DOCKER_IMAGE):$(DOCKER_TAG)

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BIN_DIR)
	cd $(BACKEND_DIR) && $(GO) clean ./...

## tidy: Tidy go modules
tidy:
	@echo "Tidying go modules..."
	cd $(BACKEND_DIR) && $(GO) mod tidy

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/ /'
