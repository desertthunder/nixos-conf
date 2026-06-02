# Git

## What this config does

Home Manager configures Git identity and a global ignore list.

## Nix location

- `conf/shared.nix`: `programs.git`

Configured identity:

```text
Owais Jamil <desertthunder.dev@gmail.com>
```

Global ignores:

```text
.DS_Store
Thumbs.db
*~
*.swp
*.swo
.env
.env.*
!.env.example
.direnv/
.devenv/
result
result-*
.sandbox/
AGENTS.md
CLAUDE.md
```

## Portable setup

Set identity:

```bash
git config --global user.name 'Owais Jamil'
git config --global user.email 'desertthunder.dev@gmail.com'
```

Create a global ignore file:

```bash
cat > ~/.gitignore_global <<'EOF'
.DS_Store
Thumbs.db
*~
*.swp
*.swo
.env
.env.*
!.env.example
.direnv/
.devenv/
result
result-*
.sandbox/
AGENTS.md
CLAUDE.md
EOF

git config --global core.excludesfile ~/.gitignore_global
```

## SSH remotes

SSH host config lives on the [SSH](./ssh.md) page. SOPS key extraction lives on
the [Secrets](../secrets.md) page.

## Check it

```bash
git config --global --get user.name
git config --global --get user.email
git config --global --get core.excludesfile
```
