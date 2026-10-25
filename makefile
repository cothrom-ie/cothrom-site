# =============================================================================
# Cothrom site — Hugo build
# =============================================================================
# publishDir = site (matches compose.yml volume ./site)
# Hugo Extended ≥ 0.158 required (No Fate). Local binary: ./bin/hugo

SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

HUGO_VERSION ?= 0.158.0
HUGO_BIN := ./bin/hugo
HUGO ?= $(shell if [ -x "$(HUGO_BIN)" ]; then echo "$(HUGO_BIN)"; elif command -v hugo >/dev/null 2>&1; then command -v hugo; else echo "$(HUGO_BIN)"; fi)
PUBLISH_DIR := site
HUGO_CACHEDIR ?= $(CURDIR)/temp/hugo_cache
export HUGO_CACHEDIR
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_linux-amd64.tar.gz

.PHONY: help hugo-install build serve clean check-hugo

help: ## Show available targets
	@echo "Available targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/  \1|\2/' | column -t -s '|'

hugo-install: ## Download Hugo Extended $(HUGO_VERSION) into ./bin/hugo
	@mkdir -p bin temp
	@curl -fsSL -o temp/hugo.tgz "$(HUGO_URL)"
	@tar -xzf temp/hugo.tgz -C bin hugo
	@chmod +x bin/hugo
	@rm -f temp/hugo.tgz
	@$(HUGO_BIN) version

check-hugo: ## Fail if Hugo Extended < 0.158
	@test -x "$(HUGO)" || { echo "Hugo not found. Run: make hugo-install"; exit 1; }
	@$(HUGO) version
	@$(HUGO) version | grep -qi extended || { echo "Hugo Extended required"; exit 1; }

build: check-hugo ## Production build → ./site
	@$(HUGO) --gc --minify
	@test -f "$(PUBLISH_DIR)/index.html"
	@echo "Built → $(PUBLISH_DIR)/"

serve: check-hugo ## Dev server (bind 127.0.0.1)
	@$(HUGO) server --bind 127.0.0.1 --baseURL http://127.0.0.1:1313/

clean: ## Remove publish output and Hugo caches
	@rm -rf "$(PUBLISH_DIR)" public resources/_gen .hugo_build.lock temp/hugo_cache
	@echo "Cleaned $(PUBLISH_DIR)/ public/ resources/_gen temp/hugo_cache"
