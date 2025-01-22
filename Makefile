TOOLS_BIN_DIR ?= $(shell pwd)/tmp/bin
export PATH := $(TOOLS_BIN_DIR):$(PATH)

$(TOOLS_BIN_DIR):
	mkdir -p $(TOOLS_BIN_DIR)

GOTESTSUM := $(TOOLS_BIN_DIR)/gotestsum

TOOLING=$(GOTESTSUM)

$(TOOLING): $(TOOLS_BIN_DIR)
	@echo Installing tools from scripts/tools.go
	@cat scripts/tools.go | grep _ | awk -F'"' '{print $$2}' | GOBIN=$(TOOLS_BIN_DIR) xargs -tI % go install -mod=readonly -modfile=scripts/go.mod %



CURR_MOD := $(shell go list -m | tr '/' '-' )

test: $(TOOLING)
	$(GOTESTSUM) --rerun-fails=1 --packages="./..." --junitfile test-results.xml -- -race ./...