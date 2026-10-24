# =============================================================================
# Vibe Dev Template Makefile
# =============================================================================

# Automatic hostname detection
DETECTED_HOST := $(shell hostname)
HOST ?= $(DETECTED_HOST)

# Directories
SCRIPTS_DIR := ./scripts
TEMP_DIR := ./temp
USERNAME := $(USER)

# Shell
SHELL := /bin/bash

# Enable better error handling
.ONESHELL:
.SHELLFLAGS := -e -u -o pipefail -c

# Default target
.DEFAULT_GOAL := help

# Phony targets (targets that don't represent files)
.PHONY:

# =============================================================================
# Help Target
# =============================================================================

help: ## Show this help message
	@echo "Available targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep | sed -e 's/\([^:]*\):[^#]*##\(.*\)/  \1|\2/' | column -t -s '|'

up:

down:

pull:
