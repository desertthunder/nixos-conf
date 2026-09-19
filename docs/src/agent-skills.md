# Agent skills

This repository maintains four reusable skills under `conf/agent/skills/`:

| Skill             | Use it for                                                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------ |
| `css`             | Vanilla CSS structure, component classes, tokens, accessible colours, and replacing utility CSS. |
| `frontend-design` | Building, redesigning, reviewing, and polishing accessible, responsive web interfaces.           |
| `svelte-testing`  | Svelte and SvelteKit unit, component, server, SSR, browser, and end-to-end testing.              |
| `writing`         | Drafting and revising prose in a direct human voice.                                             |

Each skill has a `SKILL.md` file and can include supporting files:

```text
conf/agent/skills/<skill>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

Only `SKILL.md` is required. Keep detailed references, examples, templates, and
helper programs beside it so the skill remains self-contained.

## How skills load

An agent scans its configured skill directories at startup and puts each
skill's name and description into the model context. The model reads the full
`SKILL.md` only when the request matches that description. This keeps inactive
skill instructions out of the context.

Pi scans both `~/.agents/skills/` and `~/.pi/agent/skills/` for global skills. It
also scans `.agents/skills/` and `.pi/skills/` in trusted projects. Skills can
also come from installed Pi packages, the `skills` setting, or repeated
`--skill <path>` arguments.

Use `/skill:<name>` in Pi to load a skill explicitly. For example:

```text
/skill:writing revise docs/src/introduction.md
```

## Skill format

`SKILL.md` starts with YAML frontmatter:

```yaml
---
name: css
description: Write, refactor, and review well-structured vanilla CSS...
---
```

The name must contain only lowercase letters, numbers, and hyphens. The
description should name the work and the situations that should trigger the
skill. Relative links in `SKILL.md` resolve from the skill directory.

Pi follows the [Agent Skills specification](https://agentskills.io/specification)
and reports malformed frontmatter, invalid names, missing descriptions, and
name collisions when it scans skills.

## Publishing repository skills

On NixOS, Home Manager publishes the complete repository skill directory at
`~/.agents/skills`:

```nix
home.file.".agents/skills" = {
  source = config.lib.file.mkOutOfStoreSymlink "${agentConfigDir}/skills";
  force = true;
};
```

This configuration is defined in `conf/shared.nix`. Changes under
`conf/agent/skills/` become available through the symlink without copying the
files.

On machines not managed by this Home Manager configuration, link each desired
skill into `~/.agents/skills/`. Linking skills individually allows repository
skills and machine-installed skills to share the directory:

```bash
mkdir -p ~/.agents/skills
ln -s "$PWD/conf/agent/skills/writing" ~/.agents/skills/writing
```

Pi and Codex both discover skills from `~/.agents/skills/`, so a second copy in
an agent-specific directory is usually unnecessary. Review third-party skills
before installing them because their instructions and scripts run with the
agent's permissions.

Claude Code does not read `~/.agents/skills/`. It scans `~/.claude/skills/`, so
Home Manager publishes the same directory a second time:

```nix
home.file.".claude/skills" = {
  source = config.lib.file.mkOutOfStoreSymlink "${agentConfigDir}/skills";
  force = true;
};
```

Both links point at `conf/agent/skills/`, so there is still one copy to edit.
The frontmatter this repository already uses satisfies Claude Code, which
requires `name` and `description` and nothing else.

The script `conf/agent/link-global-instructions.sh` installs the same links on
machines without Home Manager. It links `AGENTS.md` for Codex, Pi, and Claude
Code, and links the skill directory for Claude Code.

## Updating a skill

Put short operating instructions in `SKILL.md`. Put long source notes,
templates, catalogs, and examples in `references/`. Keep project-specific facts
in the owning project's documentation rather than in a reusable skill.

After changing a skill, start a new agent session so the harness scans its
frontmatter again. In Pi, `/skill:<name>` can then confirm that the expected
skill loads.
