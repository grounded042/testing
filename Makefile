
GIT_SHA=$(shell git rev-parse HEAD)
GIT_CLOSEST_TAG=$(shell git describe --abbrev=0 --tags)
DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_INFO_IMPORT_PATH=github.com/jaegertracing/jaeger/pkg/version
BUILD_INFO=-ldflags "-X $(BUILD_INFO_IMPORT_PATH).commitSHA=$(GIT_SHA) -X $(BUILD_INFO_IMPORT_PATH).latestVersion=$(GIT_CLOSEST_TAG) -X $(BUILD_INFO_IMPORT_PATH).date=$(DATE)"

.PHONY: build-agent-windows
build-agent-windows:
	CGO_ENABLED=0 GOOS=windows installsuffix=cgo go build -o ./cmd/agent/agent-windows $(BUILD_INFO) ./cmd/agent/main.go

.PHONY: build-agent-linux
build-agent-linux:
	CGO_ENABLED=0 GOOS=linux installsuffix=cgo go build -o ./cmd/agent/agent-linux $(BUILD_INFO) ./cmd/agent/main.go

.PHONY: build-agent-darwin
build-agent-darwin:
	CGO_ENABLED=0 GOOS=darwin installsuffix=cgo go build -o ./cmd/agent/agent-darwin $(BUILD_INFO) ./cmd/agent/main.go

.PHONY: build-collector-windows
build-collector-windows:
	CGO_ENABLED=0 GOOS=windows installsuffix=cgo go build -o ./cmd/collector/collector-windows $(BUILD_INFO) ./cmd/collector/main.go

.PHONY: build-collector-linux
build-collector-linux:
	CGO_ENABLED=0 GOOS=linux installsuffix=cgo go build -o ./cmd/collector/collector-linux $(BUILD_INFO) ./cmd/collector/main.go

.PHONY: build-collector-darwin
build-collector-darwin:
	CGO_ENABLED=0 GOOS=darwin installsuffix=cgo go build -o ./cmd/collector/collector-darwin $(BUILD_INFO) ./cmd/collector/main.go

.PHONY: build-linux
build-linux: build-agent-linux build-collector-linux

.PHONY: build-darwin
build-darwin: build-agent-darwin build-collector-darwin

.PHONY: build-windows
build-windows: build-agent-windows build-collector-windows

.PHONY: echo-version
echo-version:
	@echo $(GIT_CLOSEST_TAG)
