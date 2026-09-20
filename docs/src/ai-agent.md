# AI Agents

Project-local skills are documented in [Agent skills](./agent-skills.md).

## Pi

Home Manager installs Pi from unstable Nixpkgs. Pi packages remain local because
Pi manages their files and records them in `~/.pi/agent/settings.json`.

Install the [MCP adapter](https://pi.dev/packages/pi-mcp-adapter) with Pi's
package manager:

```bash
pi install npm:pi-mcp-adapter
```

Restart Pi after installation. If an MCP config already exists at `.mcp.json`
or `~/.config/mcp/mcp.json`, the adapter loads it automatically. Otherwise,
start Pi and run:

```text
/mcp setup
```

Use `.mcp.json` for project servers and `~/.config/mcp/mcp.json` for servers
that should be available in all projects. Check the installation with:

```bash
pi list
```

Pi packages can execute code with the user's permissions. Review the adapter's
[source](https://github.com/nicobailon/pi-mcp-adapter) before installing or
updating it.

## Codex

Log in through the TUI.

## Claude Code

Home Manager installs the standard Claude Code package from unstable Nixpkgs.
No provider or authentication settings are managed by this repo. Run `claude`
and follow its login flow.

Four files are linked into `~/.claude/`:

| Link             | Source                              | Purpose                        |
| ---------------- | ----------------------------------- | ------------------------------ |
| `CLAUDE.md`      | `conf/agent/AGENTS.md`              | Global instructions.           |
| `skills/`        | `conf/agent/skills/`                | Repository skills.             |
| `settings.json`  | `conf/agent/claude-settings.json`   | Status line, effort, theme.    |
| `statusline.sh`  | `conf/agent/claude-statusline.sh`   | Status line renderer.          |

`settings.json` sets `effortLevel` to `high` for `claude-opus-5`, the theme to
`dark-ansi`, and points `statusLine` at `$HOME/.claude/statusline.sh`. The
script reads Claude Code's JSON status payload on stdin and prints the working
directory, git branch, model name, and the remaining share of the context
window and of the five-hour and seven-day rate limits.

Claude Code writes to `settings.json` itself, so the link points out of the Nix
store at the repository file. Changing the theme with `/config` edits
`conf/agent/claude-settings.json` and shows up in `git status`. Commit the
change or revert it. If Claude Code ever replaces the symlink with a regular
file, copy that file back over `conf/agent/claude-settings.json` and rebuild;
otherwise the next rebuild fails on the conflict, because
`home-manager.backupFileExtension` is `null`.

## OpenCode

Home Manager installs OpenCode from unstable Nixpkgs. Run `opencode` and follow
its provider setup flow.

## Reviewing agent changes

Home Manager installs [hunk](https://github.com/modem-dev/hunk) from unstable
Nixpkgs on every machine. It is a terminal diff viewer for agent-authored
changesets and reads Git, Jujutsu, and Sapling repositories. Every review starts from
a subcommand:

```bash
hunk diff
hunk diff --staged
hunk diff --watch
hunk show
```

`hunk diff --watch` reloads as the agent edits files. Nothing about hunk is
configured here; run `hunk --help` for layout, theme, and extension options.

## Ownership

- `conf/shared.nix`: `pkgsUnstable.claude-code`
- `conf/shared.nix`: `pkgsUnstable.opencode`
- `conf/shared.nix`: `pkgsUnstable.hunk`
- `conf/shared.nix`: the `home.file` links into `~/.claude/`
- `conf/agent/`: `AGENTS.md`, `skills/`, `claude-settings.json`,
  `claude-statusline.sh`

## Validate

After rebuilding, open a fresh shell and run:

```bash
claude doctor
opencode --version
hunk --version
```

Check that the Claude Code links resolve into the repository:

```bash
readlink -f ~/.claude/CLAUDE.md ~/.claude/skills ~/.claude/settings.json
```
