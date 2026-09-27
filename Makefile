# vpcdrain Makefile - Deterministic AWS VPC Teardown Engine

BINARY_NAME := vpcdrain
MODULE := github.com/x7ssss/vpcdrain
VERSION := 1.0.0
BUILD_DIR := bin
LDFLAGS := -s -w -X main.version=$(VERSION)

.PHONY: all build test test-cover lint clean cross-compile help

all: test build

## build: Build static binary for host platform (CGO_ENABLED=0)
build:
	CGO_ENABLED=0 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME) ./cmd/vpcdrain

## test: Run all unit and integration tests
test:
	go test -v ./...

## test-cover: Run tests with code coverage report
test-cover:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

## lint: Run go vet and static analysis
lint:
	go vet ./...

## clean: Remove build artifacts and temporary binaries
clean:
	rm -rf $(BUILD_DIR) coverage.out coverage.html *.exe

## cross-compile: Build static binaries for Linux, macOS, and Windows (AMD64 & ARM64)
cross-compile: clean
	@mkdir -p $(BUILD_DIR)
	# Linux AMD64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 ./cmd/vpcdrain
	# Linux ARM64
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME)-linux-arm64 ./cmd/vpcdrain
	# macOS AMD64
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 ./cmd/vpcdrain
	# macOS ARM64 (Apple Silicon)
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 ./cmd/vpcdrain
	# Windows AMD64
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe ./cmd/vpcdrain

help:
	@echo "vpcdrain Build Commands:"
	@echo "  make build         - Build static binary for current platform"
	@echo "  make test          - Run all tests"
	@echo "  make test-cover    - Run tests with HTML coverage report"
	@echo "  make lint          - Run go vet"
	@echo "  make cross-compile - Build static binaries for Linux, macOS, Windows"
	@echo "  make clean         - Remove build outputs"
