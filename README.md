<div align="center">

# ⚡ ansible-shell-setup

**A fully automated, idempotent Ansible playbook that turns any Debian/Ubuntu machine into a productive developer shell in under 5 minutes.**

[![Ansible Lint](https://github.com/yourname/ansible-shell-setup/actions/workflows/lint.yml/badge.svg)](https://github.com/yourname/ansible-shell-setup/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/Ansible-2.14%2B-red?logo=ansible)](https://docs.ansible.com)

</div>

---

## ✨ What gets installed

| Component | Description |
|---|---|
| **Zsh** | Main shell, set as default |
| **Oh My Zsh** | Plugin framework with auto-update |
| **Powerlevel10k** | Ultra-fast prompt with 15+ context-aware segments |
| **MesloLGS NF** | Nerd Font with full icon support for P10k |
| **Atuin** | Magical shell history (fuzzy search, sync-ready) |
| **lsd** | Modern `ls` with icons and colours |
| **bat** | `cat` with syntax highlighting and line numbers |
| **fzf** | Fuzzy finder — `Ctrl+R`, `Ctrl+T`, `Alt+C` |
| **ripgrep** | Blazing-fast `grep` replacement |
| **80+ aliases** | Git, Docker, Kubernetes, apt, network, and more |
| **Shell functions** | `extract`, `mkcd`, `netinfo`, `sysinfo`, `genpass`, and more |

---

## 🖥️ Prompt overview

The Powerlevel10k prompt shows rich context while staying fast and uncluttered — segments only appear when they are relevant.

```
 ~/p/my-app  main ✔   󰎙 20.11  󰟓 1.22       󱃾 dev:default  12:34
❯
```

### Left side

| Segment | Description |
|---|---|
| OS icon | Linux / macOS / WSL icon |
| `context` | `user@host` — shown only over SSH or with infra commands |
| `dir` | Smart-truncated path, anchored at project roots |
| `vcs` | Branch + staged / unstaged / untracked / conflict / ahead / behind |

### Right side — added in this release

| Segment | Shown when… |
|---|---|
| `status` | Last command exited non-zero |
| `command_execution_time` | Last command took ≥ 3 s |
| `background_jobs` | At least one suspended or background job |
| `node_version` | `package.json` / `.nvmrc` / `.node-version` in tree |
| `go_version` | `go.mod` / `.go-version` in tree |
| `rust_version` | `Cargo.toml` / `rust-toolchain` in tree |
| `python_version` | `pyproject.toml` / `.python-version` in tree |
| `aws` | `AWS_PROFILE` set and running an AWS-related command |
| `terraform` | Running `terraform` / `terragrunt` / `tofu` |
| `kubecontext` | Running `kubectl` / `helm` / `k` and friends |
| `load` | Always — colour shifts green → yellow → red with load |
| `ram` | Always — shows available RAM |
| `disk_usage` | Only when disk usage ≥ 85 % (warning) or ≥ 95 % (critical) |
| `ip` | Always — local IP of the primary network interface |
| `time` | Always — `HH:MM` |

> **Tip:** Run `p10k configure` after installation to tweak the prompt interactively.

---

## 📋 Requirements

- **Control node:** any machine with Python 3.9+ and Ansible 2.14+
- **Target host:** Debian 11+ or Ubuntu 20.04+
- **SSH access** with `sudo` privileges (or `--connection local`)

### Installing Ansible

> **Debian 12+ / Ubuntu 23.04+** block `pip install` system-wide ([PEP 668](https://peps.python.org/pep-0668/)).  
> Use one of the methods below — or just run the provided script.

#### ✅ Recommended — one-liner script (auto-detects the best method)

```bash
bash install.sh
```

The script tries three strategies in order:

| # | Method | When used |
|---|---|---|
| 1 | **pipx** (isolated, PEP 668-safe) | Default — installs pipx first if needed |
| 2 | **apt** (`ansible` / `ansible-core`) | When pipx is unavailable |
| 3 | **pip `--break-system-packages`** | Last resort, with explicit warning |

#### Manual options

```bash
# Option A — pipx (recommended, works on Debian 12+ / Ubuntu 23.04+)
sudo apt install -y pipx python3-full
pipx install --include-deps ansible
pipx ensurepath        # adds ~/.local/bin to PATH
source ~/.bashrc       # reload PATH in current shell

# Option B — apt (ansible-core, minimal but always works)
sudo apt update && sudo apt install -y ansible-core

# Option C — pip with explicit system override (use with caution)
pip install --break-system-packages ansible
```

---

## 🚀 Quick start

### 1. Clone

```bash
git clone https://github.com/yannisduvignau/ansible-shell-setup.git
cd ansible-shell-setup
```

### 2. Configure inventory

Edit `inventory.ini`:

```ini
[servers]
my-server ansible_host=192.168.1.100 ansible_user=ubuntu
```

### 3. Run

```bash
# Full setup
ansible-playbook site.yml

# Ask for sudo password
ansible-playbook site.yml --ask-become-pass

# Local machine (no SSH)
ansible-playbook site.yml -i "localhost," --connection local

# Specific host
ansible-playbook site.yml -l my-server

# Different user than the SSH user
ansible-playbook site.yml -e shell_user=alice

# Dry run
ansible-playbook site.yml --check
```

### 4. After installation

1. Close and reopen your terminal
2. Set your terminal font to **MesloLGS NF**
3. Enjoy the prompt 🎉

---

## 🗂️ Project structure

```
ansible-shell-setup/
├── site.yml                        # Main playbook
├── ansible.cfg                     # Ansible configuration
├── inventory.ini                   # Host inventory
├── vars/
│   └── main.yml                    # Global variables
├── roles/
│   ├── packages/                   # apt packages
│   ├── zsh/                        # Zsh + default shell
│   ├── oh_my_zsh/                  # OMZ + community plugins
│   ├── powerlevel10k/              # Theme + Nerd Font + p10k config
│   ├── atuin/                      # Better shell history
│   └── shell_config/               # .zshrc, aliases, functions, exports
└── .github/
    ├── workflows/lint.yml          # Ansible-lint CI
    └── ISSUE_TEMPLATE/             # Bug & feature templates
```

---

## ⚙️ Customisation

### Change the target user

```bash
ansible-playbook site.yml -e shell_user=alice
```

### Add / remove OMZ plugins

In `vars/main.yml`:

```yaml
omz_plugins:
  - git
  - docker
  - kubectl
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - terraform        # add or remove freely
  - aws
```

### Tweak the prompt segments

Edit `roles/powerlevel10k/templates/p10k.zsh.j2`:

- **Segments:** `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` / `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`
- **Colours:** each segment has a `_FOREGROUND` variable (256-colour index)
- **Thresholds:** `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD`, `POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL`

### Add your own aliases

Edit `roles/shell_config/templates/aliases.zsh.j2`. Re-run the playbook to push updates.

---

## 🏷️ Variables reference

| Variable | Default | Description |
|---|---|---|
| `shell_user` | `{{ ansible_user }}` | User to configure |
| `shell_user_home` | `/home/<user>` | Home directory (auto-set for root) |
| `omz_install_dir` | `~/.oh-my-zsh` | Oh My Zsh path |
| `omz_theme` | `powerlevel10k/powerlevel10k` | ZSH theme |
| `omz_plugins` | See `vars/main.yml` | OMZ plugins list |
| `p10k_install_dir` | `~/.oh-my-zsh/custom/themes/powerlevel10k` | P10k path |
| `nerd_fonts_dir` | `~/.local/share/fonts` | Font installation directory |

---


---

## 🔍 Smart font detection

The `powerlevel10k` role runs a **3-step check** before touching any font file:

```
1. fc-list "MesloLGS NF"          → already in fontconfig cache? skip everything.
2. stat each .ttf on disk          → only download the missing files.
3. fc-cache -fv                    → only runs if ≥ 1 file was actually downloaded.
```

This means re-running the playbook on an already-configured machine downloads and writes **nothing** — fully idempotent.

---

## 🌐 Automatic IP interface detection

The IP segment in P10k needs to know which network interface to watch.
The role resolves it automatically via a **3-stage fallback**:

```
Stage 1 — Ansible fact (fastest)
  ansible_default_ipv4.interface
  → set by Ansible's network fact gathering; always accurate

Stage 2 — ip route (shell fallback)
  ip route show default | awk '/^default/{print $5}'
  → used when facts are unavailable (e.g. --connection local without full gather)

Stage 3 — catch-all regex
  [ewr].*|en.*|wl.*
  → last resort; matches eth*, ens*, wlan*, en* on most Debian/Ubuntu systems
```

The resolved interface name is injected directly into `~/.p10k.zsh` at deploy time:

```zsh
# example on a VM with interface ens3:
typeset -g POWERLEVEL9K_IP_INTERFACE='ens3'

# example on a laptop with interface wlan0:
typeset -g POWERLEVEL9K_IP_INTERFACE='wlan0'
```

No regex, no guessing — the exact interface is baked in.

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/)
4. Push and open a PR against `main`

---

## 📄 License

[MIT](LICENSE) © 2024 yourname
