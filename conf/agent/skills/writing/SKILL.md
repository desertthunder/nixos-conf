---
name: writing
description: Write, revise, and edit prose in a direct human voice. Use for blog posts, essays, documentation, website copy, notes, and any task where style, clarity, or avoiding common AI writing tells matters.
---

# Writing

Use this skill when drafting or editing prose. Aim for writing that sounds like a
specific person made choices, not like a model filled a template.

## Default approach

- Prefer clear, concrete language over ornate phrasing.
- Keep claims specific. Name sources, people, tools, and constraints when they
  matter.
- Preserve the user's voice, vocabulary, and level of formality.
- Cut filler before polishing.
- Use structure only when it helps the reader. Do not force numbered sections,
  summaries, or dramatic transitions.
- Vary sentence length naturally, but avoid manufactured punchiness.
- If the user asks for a draft, write the draft. Do not preface it with a long
  explanation.
- If the user asks for an edit, make the smallest useful change unless they ask
  for a rewrite.

## Style guardrails

Before returning prose, check it against `references/tropes.md`.

Avoid repeated use of:

- Negative reframes such as "not X, but Y" or "it isn't X, it's Y".
- Rhetorical question setups such as "The result?".
- Stock transitions such as "here's the thing", "it's worth noting", "importantly",
  "in conclusion", and "let's break this down".
- Grand abstractions such as "landscape", "tapestry", "ecosystem", "paradigm",
  and "synergy" unless they are the exact right word.
- Inflated verbs such as "leverage", "utilize", "harness", and "streamline" when
  simple verbs work.
- Excessive em dashes, bold-first bullets, unicode arrows, and decorative
  formatting.
- Vague authorities such as "experts say" unless a source is named.
- Invented concept labels that sound analytical but skip the argument.

One instance of a pattern may be fine. Repetition is the problem.

## Editing checklist

When revising prose:

1. Identify the audience and purpose from the user's request or the existing text.
2. Keep the strongest specific details.
3. Remove throat-clearing, duplicated ideas, and template conclusions.
4. Replace generic abstractions with concrete nouns and verbs.
5. Read for rhythm: combine choppy fragments, split overloaded sentences, and
   keep punctuation plain.
6. Return either the revised text or a compact list of changes, depending on what
   the user asked for.

## Reference

- `references/tropes.md`: AI writing tropes to avoid, copied from the user's
  `.sandbox/tropes.md` file.
