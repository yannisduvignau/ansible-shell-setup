# ⚡ ansible-shell-setup

**Automated, idempotent Ansible playbook that turns any fresh Debian/Ubuntu or macOS machine into a fully equipped developer shell — in under 5 minutes.**

[![Ansible Lint](https://github.com/yannisduvignau/ansible-shell-setup/actions/workflows/lint.yml/badge.svg)](https://github.com/yannisduvignau/ansible-shell-setup/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/Ansible-2.14%2B-red?logo=ansible)](https://docs.ansible.com)
[![Platform](https://img.shields.io/badge/Platform-Debian%20%7C%20macOS-blue)](#-requirements)

---

## ✨ What gets installed

| Component | Description |
|---|---|
| **Zsh** | Main shell, set as default |
| **Oh My Zsh** | Plugin framework with silent auto-update |
| **Powerlevel10k** | Ultra-fast prompt with 15+ context-aware segments |
| **MesloLGS NF** | Nerd Font with full icon support for P10k |
| **Atuin** | Fuzzy shell history with sync support |
| **lsd** | Modern `ls` with icons and colours |
| **bat** | `cat` with syntax highlighting and line numbers |
| **fzf** | Fuzzy finder — `Ctrl+R`, `Ctrl+T` |
| **ripgrep** | Blazing-fast `grep` replacement |
| **htop / neofetch** | System monitoring |
| **jq** | JSON processor |
| **80+ aliases** | Git, Docker, Kubernetes, network, and more |
| **Shell functions** | `extract`, `mkcd`, `netinfo`, `sysinfo`, `genpass`, and more |

---

## 🖥️ Prompt overview

Powerlevel10k shows rich context while staying fast and uncluttered — segments only appear when relevant.

```
╭─  ~/p/my-app  on  main ✔   󰎙 20.11   󰟓 1.22   󱃾 dev:default   192.168.1.10 󰩟  12:34
╰─❯
```

### Left side

| Segment | Description |
|---|---|
| OS icon | 🍎 macOS / 🐧 Linux |
| `context` | `user@host` — shown only over SSH or with infra commands |
| `dir` | Smart-truncated path, anchored at project roots |
| `vcs` | Branch + staged / unstaged / untracked / conflicts / ahead / behind |

### Right side

| Segment | Shown when… |
|---|---|
| `status` | Last command exited non-zero |
| `command_execution_time` | Last command took ≥ 3 s |
| `background_jobs` | At least one background or suspended job |
| `node_version` | `package.json` / `.nvmrc` in tree |
| `go_version` | `go.mod` / `.go-version` in tree |
| `rust_version` | `Cargo.toml` / `rust-toolchain` in tree |
| `python_version` | `pyproject.toml` / `.python-version` in tree |
| `aws` | `AWS_PROFILE` set + running an AWS-related command |
| `terraform` | Running `terraform` / `terragrunt` / `tofu` |
| `kubecontext` | Running `kubectl` / `helm` / `k` and friends |
| `load` | Always — colour shifts green → yellow → red |
| `ram` | Always — available RAM |
| `disk_usage` | Disk usage ≥ 85% (warning) or ≥ 95% (critical) |
| `ip` | Always — local IP of primary interface (auto-detected) |
| `time` | Always — `HH:MM` |

> **Tip:** Run `p10k configure` after installation to tweak the prompt interactively.

---

## 📋 Requirements

### Control node
- Python 3.9+
- Ansible 2.14+

### Target host

| Platform | Version |
|---|---|
| Debian | 11+ (Bullseye, Bookworm) |
| Ubuntu | 20.04+ |
| macOS | 12+ (Monterey and later, Apple Silicon & Intel) |

SSH access with `sudo` privileges is required for remote targets. For local setups, use `--connection local`.

---

## 🔧 Installing Ansible

> **Debian 12+ / Ubuntu 23.04+** block `pip install` system-wide ([PEP 668](https://peps.python.org/pep-0668/)).
> Use one of the options below, or run the provided install script.

### Recommended — one-liner script

```bash
bash install.sh
```

The script auto-detects the best installation method:

| # | Method | When used |
|---|---|---|
| 1 | **pipx** (isolated, PEP 668-safe) | Default — installs pipx first if needed |
| 2 | **apt** (`ansible` / `ansible-core`) | When pipx is unavailable |
| 3 | **pip `--break-system-packages`** | Last resort, with explicit warning |

### Manual options

```bash
# Option A — pipx (recommended for Debian 12+ / Ubuntu 23.04+)
sudo apt install -y pipx python3-full
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc

# Option B — apt
sudo apt update && sudo apt install -y ansible-core

# Option C — Homebrew (macOS)
brew install ansible
```

---

## 🚀 Quick start

### 1. Clone

```bash
git clone https://github.com/yannisduvignau/ansible-shell-setup.git
cd ansible-shell-setup
```

### 2. Configure inventory (remote only)

Edit `inventory.ini`:

```ini
[servers]
my-server ansible_host=192.168.1.100 ansible_user=ubuntu
```

### 3. Run

```bash
# Local machine — Debian
ansible-playbook site.yml -i "localhost," --connection local

# Local machine — macOS (no sudo for Homebrew)
ansible-playbook site.yml -i "localhost," --connection local --ask-become-pass

# Remote server
ansible-playbook site.yml --ask-become-pass

# Specific user
ansible-playbook site.yml -e shell_user=alice --ask-become-pass

# Dry run
ansible-playbook site.yml --check
```

### 4. After installation

1. Close and reopen your terminal
2. Set your terminal font to **MesloLGS NF**
3. Enjoy the prompt 🎉

> On macOS: Terminal → Preferences → Profiles → Font  
> On iTerm2: Preferences → Profiles → Text → Font

---

## 🗂️ Project structure

```
ansible-shell-setup/
├── site.yml                        # Main playbook
├── ansible.cfg                     # Ansible configuration
├── inventory.ini                   # Host inventory
├── install.sh                      # Ansible bootstrapper
├── vars/
│   └── main.yml                    # Global variables
└── roles/
    ├── packages/                   # apt (Debian) / Homebrew (macOS)
    ├── zsh/                        # Zsh installation + default shell
    ├── oh_my_zsh/                  # OMZ + community plugins
    ├── powerlevel10k/              # Theme + Nerd Fonts + p10k config
    ├── atuin/                      # Shell history (Homebrew/binary)
    └── shell_config/               # .zshrc, aliases, functions, exports
```

---

## ⚙️ Customisation

### Change the target user

```bash
ansible-playbook site.yml -e shell_user=alice
```

### Add or remove OMZ plugins

Edit `vars/main.yml`:

```yaml
omz_plugins:
  - git
  - docker
  - kubectl
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - terraform
  - aws
```

### Tweak the prompt segments

Edit `roles/powerlevel10k/templates/p10k.zsh.j2`:

- **Segments** → `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` / `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`
- **Colours** → each segment has a `_FOREGROUND` variable (256-colour index)
- **Thresholds** → `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD`, `POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL`

### Add your own aliases

Edit `roles/shell_config/templates/aliases.zsh.j2`, then re-run the playbook to push updates.

---

## 🏷️ Variables reference

| Variable | Default | Description |
|---|---|---|
| `shell_user` | `$USER` (env fallback) | User to configure |
| `shell_user_home` | Auto-detected via `$HOME` | Home directory |
| `zdotdir` | `~/.config/zshrc` (macOS) / `~` (Debian) | Zsh config directory |
| `omz_install_dir` | `~/.oh-my-zsh` | Oh My Zsh installation path |
| `omz_theme` | `powerlevel10k/powerlevel10k` | Zsh theme |
| `omz_plugins` | See `vars/main.yml` | OMZ plugin list |
| `p10k_install_dir` | `~/.oh-my-zsh/custom/themes/powerlevel10k` | Powerlevel10k path |
| `nerd_fonts_dir` | `~/.local/share/fonts` (Debian) / `~/Library/Fonts` (macOS) | Font installation directory |
| `atuin_version` | `latest` | Atuin version to install |

---

## 🔄 Idempotency

Every task is safe to re-run. The playbook detects what is already installed and skips it. Use it to:

- Bootstrap a fresh machine
- Push config updates after editing templates
- Keep multiple machines in sync

---

## 🐛 Troubleshooting

### Prompt not showing after install

Make sure your terminal font is set to **MesloLGS NF**. Without it, p10k falls back silently to a plain prompt.

### `ansible_user` is undefined

Pass the user explicitly:

```bash
ansible-playbook site.yml -i "localhost," --connection local -e shell_user=$(whoami)
```

### Locale error on Debian

```bash
sudo sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=fr_FR.UTF-8
exec zsh
```

### Homebrew refuses to run as root (macOS)

The playbook handles this automatically with `become: false` on Homebrew tasks. If you encounter this manually, never run `brew` as root.

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit using [Conventional Commits](https://www.conventionalcommits.org/)
4. Push and open a PR against `main`

---

## 📄 License

[MIT](LICENSE) © 2024 yannisduvignau