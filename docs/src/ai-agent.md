# AI Agents

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

## Nix location

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

`/status` should show the Umans base URL. `/model` should show the configured
models or the aliases mapped to those models.
