---
name: disk-cleanup
description: Free disk space on Owais's machines without losing work. Use when the disk is filling up, when asked to clean up stale projects, build artifacts, caches, or old toolchains, or when free space falls below the 150 GB target.
---

# Disk cleanup

The goal is about 150 GB free. Rebuildable data goes first, then projects that
are safe to clone again, then anything that needs a decision from Owais.

Nothing is deleted without Owais approving that batch. Prefer `trash` (built
into macOS) over `rm`, so a mistake can be undone from the Finder Trash until
it is emptied.

## Tools

- `sweep` reports free space against the target and classifies every Git
  repository under `~/Projects`. It never deletes. Source:
  `conf/scripts/dotscripts/sweep.py`.
- `mo` (Mole) removes build artifacts, caches, installers, and apps. Every
  command used here takes `--dry-run`. macOS only.
- `dust -d 1 <dir>` shows what is large in a directory. It works on Linux too.

## Order of work

1. Run `sweep` and `dust -d 1 ~` to measure. Report free space and the biggest
   directories before proposing anything.
2. Build artifacts. Run `mo purge --dry-run` and summarize it. After approval,
   Owais runs `mo purge` and selects the items to remove. Mole skips artifacts
   modified in the last 7 days, and it skips a directory when its scan times
   out. Its summary says "Some artifacts were skipped"; rerun with `--debug`
   to name them and list them for Owais.
3. Caches and installers. Run `mo clean --dry-run` and
   `mo installer --dry-run`, summarize, and wait for approval.
4. Stale projects. Only the `stale` verdict from `sweep` qualifies: clean,
   fully pushed, and no commits for 180 days. Present them as a list with
   sizes, and trash the ones Owais approves.
5. Local work. Never remove a `local work` project. List each with the reason
   `sweep` gives (no remote, changed files, stashes, unpushed commits) and ask
   whether to push, archive, or keep it.
6. Toolchains and apps. Ask which language ecosystems are no longer used, then
   remove them with their own tools (`rustup toolchain uninstall`,
   `ghcup rm`, `brew uninstall`) and remove apps with `mo uninstall`.
7. Run `sweep` again and report the space recovered.

## Rules

- On NixOS, use `nix-collect-garbage` and `nix store optimise` for the store,
  and `sweep` plus `dust` for everything else. Mole does not run there.
- Treat a project that shares a remote with another checkout as a duplicate
  only after comparing both with `git status` and `git log --branches --not
  --remotes`.
- Downloads, media, and documents belong to Owais. Report their sizes and
  leave the decision to Owais.
