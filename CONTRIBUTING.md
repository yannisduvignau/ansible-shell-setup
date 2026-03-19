# Contributing to ansible-shell-setup

Thank you for taking the time to contribute! 🎉

## Development setup

```bash
git clone https://github.com/yourname/ansible-shell-setup.git
cd ansible-shell-setup
pip install ansible ansible-lint
```

## Running the linter

```bash
ansible-lint
```

## Testing locally

```bash
# Dry-run on localhost
ansible-playbook site.yml -i "localhost," --connection local --check
```

## Commit style

Please use [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | When to use |
|---|---|
| `feat:` | New role, segment, alias, or function |
| `fix:` | Bug fix |
| `docs:` | README, comments |
| `chore:` | Dependency bump, CI tweak |
| `refactor:` | Code restructure, no behaviour change |

## Pull request checklist

- [ ] `ansible-lint` passes with no errors
- [ ] Playbook runs idempotently (two consecutive runs show 0 changes)
- [ ] New variables are documented in `vars/main.yml` and the README table
- [ ] Commit messages follow Conventional Commits

## Reporting bugs

Use the [Bug Report](.github/ISSUE_TEMPLATE/bug_report.md) template.
Include your Ansible version (`ansible --version`) and the full error output.
