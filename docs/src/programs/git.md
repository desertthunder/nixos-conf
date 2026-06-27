# Git

Home Manager configures Git identity and a global ignore list.

## Summary

| Setting           | Value                                       |
| ----------------- | ------------------------------------------- |
| Ignore source     | `programs.git.ignores` in `conf/shared.nix` |
| SSH config        | [SSH](./ssh.md)                             |
| Secret extraction | [Secrets](../secrets.md)                    |

## Ignore Policy

The global ignore list covers OS/editor junk, local env files, Nix build
results, direnv/devenv state, sandbox output, and local agent files such as
`AGENTS.md`, `CLAUDE.md`, and `.claude/settings.local.json`.

## Validate

| Check    | Command                                |
| -------- | -------------------------------------- |
| Name     | `git config --global --get user.name`  |
| Email    | `git config --global --get user.email` |
| SSH auth | `ssh -T git@github.com`                |
