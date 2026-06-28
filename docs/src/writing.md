# Writing docs

I'm a bit pedantic when it comes to my [writing](https://garden.desertthunder.dev).

The key (for me) is to write these docs like working notes and not marketing copy.

Use direct sentences.

Name the command, file, or setting.

Keep filler to a minimum and focus on readability.
Cut filler such as

Prefer:

```md
Run `nix flake show --no-write-lock-file` after editing `flake.nix`.
```

Avoid:

```md
It's worth noting that this command serves as a useful way to validate the flake.
```

## Checklist

### Quality

- Ask yourself if you'll actually read this.
  Overly long/verbose documentation is ostensibly useless.
- Do not summarize a section after already explaining it.
- Keep one point per paragraph.

### Style

- Use commands and paths when they answer the question faster than prose.
- Avoid vague claims such as "important", "powerful", or "useful" unless the
  sentence explains why.
- Remove filler openings.
  - "it's worth noting"
  - "the goal is"
  - "this serves as"
  - "despite these challenges".
- Replace passive voice when the actor matters.
