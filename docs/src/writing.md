# Writing docs

I'm a bit pedantic when it comes to my [writing](https://garden.desertthunder.dev).

These docs are working notes, not marketing copy. Use direct sentences, and name
the command, file, or setting.

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

- Ask whether you would actually read it. Long documentation goes unread.
- Do not summarize a section you just explained.
- Keep one point per paragraph.

### Style

- Use commands and paths when they answer the question faster than prose.
- Drop vague claims such as "important", "powerful", or "useful" unless the
  sentence says why.
- Cut filler openings: "it's worth noting", "the goal is", "this serves as",
  "despite these challenges".
- Replace passive voice when the actor matters.
