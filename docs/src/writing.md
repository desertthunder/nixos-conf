# Writing docs

I'm a bit pedantic when it comes to [my](https://desertthunder.dev) [writing](https://garden.desertthunder.dev).

The key (for me) is to write these docs like working notes and not product copy.

Use direct sentences.

Name the command, file, or setting. Cut filler such as
"it's worth noting", "the goal is", "this serves as", and "despite these
challenges".

Prefer:

```md
Run `nix flake show --no-write-lock-file` after editing `flake.nix`.
```

Avoid:

```md
It's worth noting that this command serves as a useful way to validate the flake.
```

## Checklist

Before committing docs:

- Remove filler openings.
- Replace passive voice when the actor matters.
- Keep one point per paragraph.
- Avoid em dashes.
- Avoid vague claims such as "important", "powerful", or "useful" unless the
  sentence explains why.
- Do not summarize a section after already explaining it.
- Use commands and paths when they answer the question faster than prose.
