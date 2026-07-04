# Agent Skills

Project-local skills live under `conf/agent/skills/`. Each skill is a directory
with a `SKILL.md` file and optional `references/` files.

## How skills are triggered

Skills are selected by the agent, not by a shell command. The harness exposes the
frontmatter from each `SKILL.md`:

```yaml
---
name: css
description: Write, refactor, and review well-structured vanilla CSS...
---
```

The agent reads the available skill names and descriptions, then loads the skill
when the user's request matches. Good descriptions matter: they should name the
work, common synonyms, and when to use the skill.

Examples:

- "Refactor this Tailwind into plain CSS" should trigger `css`.
- "Make this memo sound less AI-generated" should trigger `writing`.
- "Turn this idea into a PRD" should trigger `spec-writing`.
- "Take notes from this article" should trigger `notetaking`.
- "Add SvelteKit form action tests" should trigger `svelte-testing`.
- "Audit this repo before changing it" should trigger
  `investigate-new-codebase`.

Reference files are not loaded automatically unless the skill tells the agent to
read them. Keep the main `SKILL.md` small enough to load quickly and move long
examples, templates, and catalogs into `references/`.

## Current skills

| Skill                      | Use it for                                                                                               |
| -------------------------- | -------------------------------------------------------------------------------------------------------- |
| `css`                      | Vanilla CSS structure, component classes, tokens, accessible colours, and replacing utility CSS.         |
| `investigate-new-codebase` | First-pass repo audits, legacy rescue, risk mapping, git-history analysis, and triage.                   |
| `notetaking`               | Turning articles, Markdown, or web pages into concise notes with claims, evidence, and review questions. |
| `spec-writing`             | Specs, PRDs, implementation plans, task breakdowns, acceptance criteria, and agent instructions.         |
| `svelte-testing`           | Svelte and SvelteKit unit, component, server, SSR, browser, and E2E testing.                             |
| `writing`                  | Drafting, revising, editing, and desloping prose in a direct human voice.                                |

## Installation pattern

The source of truth is always this repository:

```text
conf/agent/skills/<skill>/SKILL.md
conf/agent/skills/<skill>/references/
```

On NixOS, Home Manager publishes the project skills to Pi:

```nix
home.file.".pi/agent/skills" = {
  source = ./agent/skills;
  recursive = true;
  force = true;
};
```

For generic agent harnesses that read `~/.agents/skills`, expose project skills
with symlinks rather than copies:

```bash
mkdir -p ~/.agents/skills/css
ln -s "$PWD/conf/agent/skills/css/SKILL.md" ~/.agents/skills/css/SKILL.md
ln -s "$PWD/conf/agent/skills/css/references" ~/.agents/skills/css/references
```

Do not keep duplicate standalone skills in `~/.agents/skills` or
`~/.pi/agent/skills` when their guidance has been consolidated into this repo.
Duplicates drift and make it unclear which behavior the agent should follow.

## Self-updating pattern

A self-updating skill is a small feedback loop:

1. **Use the skill.** Let it guide real work.
2. **Notice a reusable lesson.** Prefer repeated feedback, failed outputs, or a
   missing verification step over one-off preferences.
3. **Distill the lesson.** Add the smallest concrete rule that would prevent the
   same issue next time.
4. **Choose the right file.** Put short operating rules in `SKILL.md`; put long
   examples, templates, catalogs, and source notes in `references/`.
5. **Review the change.** Human review matters because a bad skill update affects
   every future use.
6. **Let symlinks publish it.** Since `~/.agents` points back to this repo, the
   next agent run sees the update without copying files.

Each self-updating skill should include a `## Self-update` section that says when
to update it and what not to add.

Good updates:

- Add a missing checklist item after a spec causes implementation drift.
- Add a prose trope after the user repeatedly removes it.
- Add a CSS rule after the same layout mistake appears in several components.

Bad updates:

- Add project-specific facts that belong in project docs.
- Add every user preference after one comment.
- Add long examples directly to `SKILL.md` when a reference file would keep the
  trigger lightweight.

## Lessons from MindStudio's self-improving skill system

MindStudio's article on self-improving AI skill systems describes four useful
parts: a narrow skill library, shared context, eval scoring, and a learnings loop.
For this repo, the practical translation is:

- Keep skills narrow, reusable, and easy to evaluate.
- Store shared context in versioned files, not hidden chat history.
- Score outputs with concrete checks when possible: tests pass, contrast is
  readable, the spec has verification steps, the prose avoids known tells.
- Write learnings back only after review.
- Track where a learning came from, so bad guidance can be rolled back.
- Cap updates. A few high-signal rules beat a growing pile of noisy advice.
- Avoid context bloat. Promote durable lessons; leave one-off details out.

The article's fully automated loop is useful as a model, but this repository uses
a human-reviewed version. The agent may propose or make a skill update, but the
change should be concrete, versioned, and easy to inspect.

Source: <https://www.mindstudio.ai/blog/self-improving-ai-skill-system-marketing-content>
