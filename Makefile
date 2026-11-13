# Same commands locally and in CI. Written for GNU make 3.81 (macOS default).
SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help fmt fmt-check validate lint scan check

help: ## list targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  %-10s %s\n", $$1, $$2}'

fmt: ## terraform fmt -recursive
	terraform fmt -recursive

fmt-check: ## fail if a .tf file is not formatted
	terraform fmt -recursive -check -diff

validate: ## terraform validate (no backend, no cloud access)
	terraform init -backend=false -input=false >/dev/null
	terraform validate

lint: ## tflint (rules in .tflint.hcl)
	tflint --init --config "$(CURDIR)/.tflint.hcl"
	tflint --config "$(CURDIR)/.tflint.hcl"

scan: ## trivy config + gitleaks
	trivy config --exit-code 1 --severity HIGH,CRITICAL --skip-dirs '**/.terraform' --skip-dirs node_modules --quiet .
	gitleaks git --no-banner --redact .

check: fmt-check validate lint scan ## run before finishing (same as CI)
