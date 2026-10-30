# =============================================================================
# Cothrom site — Hugo build
# =============================================================================
# publishDir = site (matches compose.yml volume ./site)
# Hugo Extended ≥ 0.158 required (No Fate). Local binary: ./bin/hugo

SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

# Optional local env (gitignored; see .env.example). Mainly used to supply the
# contact-form secrets (Phase 4 / Creative C5) at build time without
# committing them: N8N_CONTACT_WEBHOOK_URL, TURNSTILE_SITE_KEY.
-include .env
export

HUGO_VERSION ?= 0.158.0
HUGO_BIN := ./bin/hugo
# Prefer ./bin/hugo only when it actually runs (avoids wrong-arch leftovers
# from another machine). Fall back to PATH hugo, else point at HUGO_BIN so
# check-hugo / hugo-install can give a clear install hint.
HUGO ?= $(shell \
	if [ -x "$(HUGO_BIN)" ] && "$(HUGO_BIN)" version >/dev/null 2>&1; then \
		echo "$(HUGO_BIN)"; \
	elif command -v hugo >/dev/null 2>&1; then \
		command -v hugo; \
	else \
		echo "$(HUGO_BIN)"; \
	fi)
PUBLISH_DIR := site
HUGO_CACHEDIR ?= $(CURDIR)/temp/hugo_cache
export HUGO_CACHEDIR

# Map uname -m → Hugo release arch (linux-amd64 / linux-arm64).
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
HUGO_ARCH := amd64
else ifeq ($(UNAME_M),amd64)
HUGO_ARCH := amd64
else ifeq ($(UNAME_M),aarch64)
HUGO_ARCH := arm64
else ifeq ($(UNAME_M),arm64)
HUGO_ARCH := arm64
else
HUGO_ARCH :=
endif
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_linux-$(HUGO_ARCH).tar.gz

# Dev server networking (make serve). Binds all interfaces by default so the
# site is reachable from other devices on the LAN (e.g. VS Code on a remote/
# headless box, phone/tablet preview) rather than only localhost.
# Override on the command line if needed, e.g.:
#   make serve LAN_IP=192.168.1.42
#   make serve BIND=127.0.0.1 LAN_IP=127.0.0.1   # old localhost-only behaviour
PORT ?= 1313
BIND ?= 0.0.0.0
LAN_IP ?= $(shell ip -4 -o addr show scope global 2>/dev/null | awk '{print $$4}' | cut -d/ -f1 | head -n1)
ifeq ($(strip $(LAN_IP)),)
LAN_IP := $(shell hostname -I 2>/dev/null | awk '{print $$1}')
endif
ifeq ($(strip $(LAN_IP)),)
LAN_IP := 0.0.0.0
endif
BASEURL ?= http://$(LAN_IP):$(PORT)/

# Local tooling venv for image optimization (gitignored). Not used by Hugo itself.
OPTIMIZE_VENV := .venv-optimize-images
OPTIMIZE_PY := $(OPTIMIZE_VENV)/bin/python
OPTIMIZE_SCRIPT := scripts/optimize-content-images.py
OPTIMIZE_REQS := scripts/requirements-optimize-images.txt
# Override on the command line, e.g.:
#   make optimize-images MAX_WIDTH=1600
#   make optimize-images DRY_RUN=1
MAX_WIDTH ?= 1920
# JFIF density written into each JPEG (screen default). Override e.g. DPI=96.
DPI ?= 72
DRY_RUN ?= 0

.PHONY: help hugo-install build serve clean check-hugo optimize-images-deps optimize-images

help: ## Show available targets
	@echo "Available targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/  \1|\2/' | column -t -s '|'

hugo-install: ## Download Hugo Extended $(HUGO_VERSION) into ./bin/hugo
	@if [ -z "$(HUGO_ARCH)" ]; then \
		echo "Unsupported architecture: $(UNAME_M) (need x86_64 or aarch64/arm64)"; \
		exit 1; \
	fi
	@mkdir -p bin temp
	@echo "Downloading Hugo Extended $(HUGO_VERSION) (linux-$(HUGO_ARCH))…"
	@curl -fsSL -o temp/hugo.tgz "$(HUGO_URL)"
	@tar -xzf temp/hugo.tgz -C bin hugo
	@chmod +x bin/hugo
	@rm -f temp/hugo.tgz
	@$(HUGO_BIN) version

check-hugo: ## Fail if Hugo Extended < $(HUGO_VERSION)
	@if [ -x "$(HUGO_BIN)" ] && ! "$(HUGO_BIN)" version >/dev/null 2>&1; then \
		echo "Found $(HUGO_BIN) but it cannot run (wrong architecture for this host)."; \
		echo "Run: make hugo-install"; \
		exit 1; \
	fi
	@test -x "$(HUGO)" || { echo "Hugo not found. Run: make hugo-install"; exit 1; }
	@if ! "$(HUGO)" version >/dev/null 2>&1; then \
		echo "Hugo at $(HUGO) cannot run. Run: make hugo-install"; \
		exit 1; \
	fi
	@"$(HUGO)" version
	@"$(HUGO)" version | grep -qi extended || { echo "Hugo Extended required"; exit 1; }
	@ver=$$("$(HUGO)" version | sed -n 's/^hugo v\([0-9.]*\).*/\1/p'); \
	IFS=. read -r maj min pat <<< "$$ver"; \
	IFS=. read -r rmaj rmin rpat <<< "$(HUGO_VERSION)"; \
	pat=$${pat:-0}; rpat=$${rpat:-0}; \
	if [ "$$maj" -lt "$$rmaj" ] || \
	   { [ "$$maj" -eq "$$rmaj" ] && [ "$$min" -lt "$$rmin" ]; } || \
	   { [ "$$maj" -eq "$$rmaj" ] && [ "$$min" -eq "$$rmin" ] && [ "$$pat" -lt "$$rpat" ]; }; then \
		echo "Hugo $$ver is too old (need Extended ≥ $(HUGO_VERSION)). Run: make hugo-install"; \
		exit 1; \
	fi

build: check-hugo ## Production build → ./site
	@HUGO_PARAMS_CONTACT_WEBHOOKURL="$${N8N_CONTACT_WEBHOOK_URL:-}" \
	 HUGO_PARAMS_CONTACT_TURNSTILESITEKEY="$${TURNSTILE_SITE_KEY:-}" \
	 $(HUGO) --gc --minify
	@test -f "$(PUBLISH_DIR)/index.html"
	@echo "Built → $(PUBLISH_DIR)/"
	@if [ -z "$${N8N_CONTACT_WEBHOOK_URL:-}" ]; then \
		echo "NOTE: N8N_CONTACT_WEBHOOK_URL not set — contact form will build with no action URL (see .env.example)."; \
	fi

serve: check-hugo ## Dev server, LAN-reachable (bind 0.0.0.0; see BASEURL/BIND overrides above)
	@echo "Serving on $(BIND):$(PORT) — open $(BASEURL) from this machine or another device on the LAN"
	@HUGO_PARAMS_CONTACT_WEBHOOKURL="$${N8N_CONTACT_WEBHOOK_URL:-}" \
	 HUGO_PARAMS_CONTACT_TURNSTILESITEKEY="$${TURNSTILE_SITE_KEY:-}" \
	 $(HUGO) server --bind $(BIND) --port $(PORT) --baseURL $(BASEURL)

clean: ## Remove publish output and Hugo caches
	@rm -rf "$(PUBLISH_DIR)" public resources/_gen .hugo_build.lock temp/hugo_cache
	@echo "Cleaned $(PUBLISH_DIR)/ public/ resources/_gen temp/hugo_cache"

optimize-images-deps: ## Create .venv-optimize-images and install Pillow
	@test -f "$(OPTIMIZE_REQS)" || { echo "Missing $(OPTIMIZE_REQS)"; exit 1; }
	@if [ ! -x "$(OPTIMIZE_PY)" ]; then \
		echo "Creating $(OPTIMIZE_VENV)…"; \
		python3 -m venv "$(OPTIMIZE_VENV)"; \
	fi
	@"$(OPTIMIZE_PY)" -m pip install --upgrade pip
	@"$(OPTIMIZE_PY)" -m pip install -r "$(OPTIMIZE_REQS)"
	@echo "Ready: $(OPTIMIZE_PY)"

optimize-images: optimize-images-deps ## Resize/re-encode content/ images → JPG max-width $(MAX_WIDTH) (in place)
	@test -f "$(OPTIMIZE_SCRIPT)" || { echo "Missing $(OPTIMIZE_SCRIPT)"; exit 1; }
	@args=(--root content --max-width "$(MAX_WIDTH)" --dpi "$(DPI)"); \
	if [ "$(DRY_RUN)" = "1" ]; then args+=(--dry-run); fi; \
	"$(OPTIMIZE_PY)" "$(OPTIMIZE_SCRIPT)" "$${args[@]}"
	@echo "Tip: run \`make build\` (or \`make clean && make build\`) so Hugo regenerates image derivatives."
