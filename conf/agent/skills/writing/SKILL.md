---
name: writing
description: Write, revise, edit, and deslop prose in a direct human voice. Use for blog posts, essays, documentation, website copy, notes, reports, scientific prose, and any task where style, clarity, or avoiding AI writing tells matters.
---

# Writing

Use this skill when drafting or editing prose. Aim for writing that sounds like a
specific person made choices, not like a model filled a template.

This skill consolidates the local writing notes with the former `skill-deslop`
skill.

## References

Read these when the task needs more detail:

- `references/tropes.md`: full catalog of AI writing tropes.
- `references/phrases.md`: phrases to remove or replace.
- `references/structures.md`: formulaic structures to avoid.
- `references/examples.md`: before/after deslop examples.

## Default approach

- When writing for Owais, treat his edited prose as the style authority. Match
  its density, directness, sentence length, and tolerance for informality.
- Keep useful operational constraints, but remove tutorial narration, repeated
  rationale, and polish that turns plain instructions into corporate prose.
- Prefer short practical paragraphs and compact lists. Explain why only when it
  changes a decision.
- Prefer clear, concrete language over ornate phrasing.
- Keep claims specific. Name sources, people, tools, and constraints when they
  matter.
- Preserve the user's voice, vocabulary, and level of formality.
- Cut filler before polishing.
- Use structure only when it helps the reader. Do not force numbered sections,
  summaries, or dramatic transitions.
- Vary sentence length naturally. Avoid manufactured punchiness.
- Match the register to the context. A blog post can use "you". Scientific prose
  may need formality, citations, and "we" for the authors' work.
- If the user asks for a draft, write the draft. Do not preface it with a long
  explanation.
- If the user asks for an edit, make the smallest useful change unless they ask
  for a rewrite.

## Structure budget

Optimize prose for reading as plain text.

- Wrap prose at 79-88 columns, depending on the final word.
- Prefer paragraphs of roughly 3-8 wrapped lines.
- Reconsider paragraphs longer than 10-12 wrapped lines.
- Keep most sections within 20-50 lines.
- Reconsider sections longer than 60-75 lines.
- Keep a single prose document or reference file under roughly 250 lines.
- Above 250-300 lines, look for a natural boundary and split the document.
- Prefer no more than three levels of headings.
  - If `####` headings become common, the document should at least have a split considered
- Prefer lists of 3-7 items. Group lists that grow beyond roughly 10 items.
- Keep list items short enough to scan; move multi-paragraph arguments back into prose.
- Treat tables as structured data, not prose.

## Deslop rules

### Cut filler

Remove throat-clearing, emphasis crutches, and meta-commentary:

- "Here's the thing"
- "Let's break this down"
- "It's worth noting"
- "In conclusion"
- "This matters because"
- "Let that sink in"
- "At its core"
- "In today's world"

State the point directly.

### Break formulaic structures

Avoid repeated use of:

- negative reframes such as "not X, but Y" or "it isn't X, it's Y";
- negative listings such as "Not a X. Not a Y. A Z.";
- self-posed rhetorical questions such as "The result?";
- dramatic fragments such as "Speed. That's it.";
- anaphora and repeated sentence openings;
- tricolon habit, where every list has three items;
- false ranges such as "from innovation to transformation" when there is no
  real spectrum.

One instance can work. Repetition is the tell.

### Use active voice with human subjects

Name the actor when possible.

- Weak: "The decision was reached."
- Better: "The team decided."

Avoid giving inanimate things human agency when a person, team, reader, or
system is doing the work.

### Be specific

Replace vague declarations with concrete claims.

- Weak: "The implications are significant."
- Better: Name the implication.

Avoid vague authorities such as "experts say" unless the source is named. Avoid
lazy extremes such as "always", "never", "everyone", and "nobody" unless they
are literally true.

### Use plain verbs

Prefer simple verbs when they work:

| Avoid      | Prefer           |
| ---------- | ---------------- |
| leverage   | use              |
| utilize    | use              |
| harness    | use, apply       |
| streamline | simplify         |
| navigate   | handle           |
| delve      | examine, look at |
| serves as  | is               |

Domain terminology is fine when it is precise. The problem is vague business
language and AI vocabulary tells leaking into otherwise clear prose.

### Trust the reader

Do not over-explain, apologize for the argument, or narrate the structure. Cut
fractal summaries: telling the reader what you will say, saying it, then
summarizing what you said.

### Name the behavior

Do not use reassuring labels in place of evidence. Words such as "safe",
"stable", "clear", "useful", "complete", and "portable" should name a defined
property or be replaced with the behavior that supports the claim.

Cut defensive closing clauses built around "without", "remains", "stays", or
"keeps" when they repeat a guarantee already stated. Resolve floating references
such as "same", "existing", and "explicit" when the reader has to infer their
noun.

Use document terminology that matches the audience. Keep milestones, tickets,
phases, and planning status in planning material. Use "contract" for a formal
interface or compatibility guarantee. Otherwise name the API, schema, format,
behavior, or rule.

State a guarantee where the documentation owns it. Elsewhere, explain the local
consequence or link to the authoritative description instead of repeating the
guarantee.

### Watch formatting tells

Avoid:

- bold-first bullets where every item starts with a bolded label;
- decorative unicode arrows;
- excessive em dashes;
- signposted conclusions;
- punchline paragraphs that all end the same way.

Use plain formatting unless the structure genuinely helps.

## Editing checklist

When revising prose:

1. Identify the audience, purpose, and register.
2. Preserve the user's strongest specific details.
3. Remove throat-clearing, duplicated ideas, and template conclusions.
4. Replace generic abstractions with concrete nouns and verbs.
5. Name actors and sources where possible.
6. Read for rhythm: combine choppy fragments, split overloaded sentences, and
   keep punctuation plain.
7. Check for fragments, tense mismatches, broken list grammar, and headings that
   promise more than their sections deliver.
8. Return either the revised text or a compact list of changes, depending on what
   the user asked for.

## Quick checks before returning prose

- Any "here's what/why" opener? Cut it.
- Any "not X, but Y" contrast? State Y directly.
- Any rhetorical question answered immediately? Fold it into a statement.
- Any vague declarative? Name the specific thing.
- Any unnamed authority? Name the source or remove the claim.
- Any inanimate subject doing a human action? Name the actor.
- Any cluster of -ly adverbs? Cut or replace them.
- Any repeated "bounded", "deliberately small", "narrow", or similar promise
  of restraint? Name the actual limit or cut the modifier.
- Any reassuring adjective standing in for evidence? Name the behavior or remove
  the adjective.
- Any defensive tail that repeats the preceding claim? Cut it.
- Any "same", "existing", or "explicit" without a clear referent? Name the noun.
- Any planning terminology outside planning material? Replace it with the
  feature, version, availability, or prerequisite the reader needs.
- Any generic use of "contract"? Name the API, schema, format, behavior, or rule.
- Any guarantee repeated across documents? Keep it in the authoritative page and
  state only the local consequence elsewhere.
- Any cluster of semicolons or colons? Rewrite with sentences or plain
  conjunctions. Use `&` only where it is part of a name or compact interface.
- Any repeated metaphor? Keep one use and remove the rest.
- Any bold-first list pattern? Remove the bold labels unless they help scanning.
- Any paragraph that only restates the previous paragraph? Delete it.

## Review scoring

When reviewing text for AI tells, score 1-10 on each dimension:

| Dimension    | Question                                      |
| ------------ | --------------------------------------------- |
| Directness   | Does it state claims, or announce them?       |
| Rhythm       | Does the rhythm vary naturally?               |
| Trust        | Does it respect the reader's intelligence?    |
| Authenticity | Does it sound like a specific human wrote it? |
| Density      | Is anything easy to cut?                      |

Below 35/50, revise before returning.

## Self-update

This is a living skill. When a writing session reveals a reusable lesson, update
this `SKILL.md` or its references with the smallest rule that would prevent the
same issue next time.

Update when:

- the user flags a phrase, structure, or tone as AI-like;
- a repeated edit pattern appears across several writing tasks;
- a reference file needs a new trope, phrase, structure, or example;
- a rule is too broad and damages the user's voice;
- the user gives a project-specific preference for prose.

Keep updates concrete, and focused on reusable writing behavior.
