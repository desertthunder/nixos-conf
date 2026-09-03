# AI Agents

Project-local skills are documented in [Agent Skills](./agent-skills.md).

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
No provider, model, or authentication settings are managed by this repo. Run
`claude` and follow its login flow.

## OpenCode

Home Manager installs OpenCode from unstable Nixpkgs. Run `opencode` and follow
its provider setup flow.

## Ownership

- `conf/shared.nix`: `pkgsUnstable.claude-code`
- `conf/shared.nix`: `pkgsUnstable.opencode`

## Validate

After rebuilding, open a fresh shell and run:

```bash
claude doctor
opencode --version
```
