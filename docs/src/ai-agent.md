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

Login in through the TUI.

## Claude Code

Home Manager installs Claude Code and writes `~/.claude/settings.json`.
Claude Code uses the Umans Anthropic-compatible API:

```text
https://api.code.umans.ai/v1/messages
```

The base URL in config is `https://api.code.umans.ai`; Claude Code appends the
Anthropic API path itself.

Authentication comes from `apiKeyHelper`, which reads:

```text
/run/secrets/umans_key
```

This keeps the API key out of the Nix store.

## Ownership

- `conf/shared.nix`: `pkgsUnstable.claude-code`
- `conf/shared.nix`: `home.file.".claude/settings.json"`
- `conf/shared.nix`: `sops.secrets.umans_key`
- `conf/secrets/owais.yaml`: encrypted `umans_key`

## Models

Default model:

```text
umans-glm-5.2
```

Fallback model:

```text
umans-coder
```

The settings map Claude Code's model aliases to Umans models:

- `fable`, `opus`, and `sonnet`: `umans-glm-5.2`
- `haiku`: `umans-coder`

Gateway model discovery is enabled. No external search provider is configured;
web search should come from the model/provider if Umans exposes it natively.

## Validate

After rebuilding, open a fresh shell and run:

```bash
claude doctor
claude
```

Inside Claude Code, run:

```text
/status
/model
```

`/status` should show the Umans base URL.

`/model` should show the configured models or the aliases mapped to those models.
