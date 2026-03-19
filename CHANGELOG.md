# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

## [1.2.1] — 2024-XX-XX

### Fixed
- `install.sh`: Ansible installation now works on Debian 12+ / Ubuntu 23.04+ without hitting the PEP 668 `externally-managed-environment` error
  - **Strategy 1**: `pipx install --include-deps ansible` (isolated venv, zero system pollution)
  - **Strategy 2**: `apt install ansible-core` fallback
  - **Strategy 3**: `pip --break-system-packages` last resort with explicit warning
- README: replaced `pip install ansible` with the full installation table + `bash install.sh` one-liner

## [1.2.0] — 2024-XX-XX

### Added
- **Font auto-detection**: `fc-list "MesloLGS NF"` is checked before any download; fonts are only downloaded if missing from both disk and fontconfig cache
- **Font idempotency**: individual font files are stat'd; only missing files are fetched (no redundant HTTP requests on re-runs)
- **`fc-cache` guard**: font cache is refreshed only when at least one font file was actually downloaded
- **IP interface auto-detection** (3-stage fallback):
  1. `ansible_default_ipv4.interface` Ansible fact (fastest, always correct)
  2. `ip route show default` shell fallback when facts are unavailable
  3. Catch-all regex `[ewr].*|en.*|wl.*` as last resort
- `p10k.zsh.j2` now injects the resolved interface name via Jinja2 — no more hardcoded regex in the deployed config
- `site.yml`: explicit `gather_facts: true` + `gather_subset: [network, hardware]`
- `roles/powerlevel10k/handlers/main.yml`: proper Ansible handler for `fc-cache`
- `roles/powerlevel10k/meta/main.yml`: Galaxy metadata, platform matrix

### Changed
- Font definitions moved from `tasks/main.yml` into `vars/main.yml` as `nerd_font_files` list — easier to add/remove variants
- `site.yml` now explicitly requests `network` and `hardware` fact subsets

## [1.1.0] — 2024-XX-XX

### Added
- P10k: `node_version`, `go_version`, `rust_version`, `python_version` segments — shown only inside matching project directories
- P10k: `aws` segment with per-environment colour coding (prod = red, staging = orange, dev = green)
- P10k: `terraform` workspace segment
- P10k: `load` — CPU load average with colour thresholds
- P10k: `ram` — available RAM
- P10k: `disk_usage` — only shown at ≥ 85 % (configurable); critical at ≥ 95 %
- P10k: `background_jobs` counter with icon
- P10k: `command_execution_time` now shows tenths of a second for sub-minute commands
- P10k: `kubecontext` now appends the namespace (skipped when `default`)
- `Dockerfile` / `docker-compose.yml` added to directory anchor list
- `.github/` with CI lint workflow and issue templates
- `CONTRIBUTING.md`, `CHANGELOG.md`, `LICENSE`, `.gitignore`

### Changed
- README rewritten in English with full segment reference table
- `context` segment now also triggers on `ansible` commands

## [1.0.0] — 2024-01-01

### Added
- Initial release: Zsh, Oh My Zsh, Powerlevel10k, Atuin, lsd, bat, fzf, ripgrep
- 80+ aliases (git, docker, kubectl, apt, network)
- Shell functions: `extract`, `mkcd`, `netinfo`, `sysinfo`, `genpass`, and more
