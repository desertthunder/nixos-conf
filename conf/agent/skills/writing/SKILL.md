---
name: writing
description: Write, revise, edit, and deslop prose in a direct human voice. Use for blog posts, essays, documentation, website copy, notes, reports, scientific prose, technical instructions, and any task where style, clarity, or avoiding AI writing tells matters.
---

# Writing

Write like a person choosing words for a reader, not a model filling a template.
Preserve the author's voice and facts. Remove whatever does not help.

This skill applies to the answer as well as the requested prose.

## References

Read only the references the task needs:

- `references/tropes.md`: current catalog of AI writing behaviors and tells.
- `references/technical-english.md`: plain technical English, controlled writing,
  and Orwell's rules.
- `references/phrases.md`: phrases to remove or replace.
- `references/structures.md`: formulaic structures to avoid.
- `references/examples.md`: before/after deslop examples.

## Response discipline

- Lead with the answer, revised text, or completed change. Do not announce it or
  restate the prompt.
- Keep planning and deliberation out of the result.
- Match the detail to the request. Do not expand into adjacent work because it
  might be useful.
- Make the point before its evidence. Do not build a paragraph that has already
  implied the point several times before stating it.
- Stop when the answer is complete. Do not add a recap, tie-back, or ceremonial
  conclusion.
- Remove before adding. Replace stale guidance instead of appending corrections
  or a changelog.
- Do not soften a necessary correction to appease the reader. Be accurate and
  civil.
- Break any style rule that would make the result wrong, unsafe, unclear, or
  unsuited to its audience.

## Choose a mode

### Voice-preserving prose

Use for essays, blog posts, notes, reports, and personal writing.

- When writing for Owais, treat his edited prose as the style authority. Match
  its density, rhythm, vocabulary, and tolerance for informality.
- Preserve distinctive phrasing when it works. Do not flatten the author's
  voice into controlled English.
- Vary sentence length naturally. Avoid both long chains and manufactured
  punchiness.
- Use metaphor, humor, fragments, and rhetorical questions only when they fit
  the author's voice and do real work.

### Plain technical prose

Use by default for documentation, READMEs, release notes, error messages, API
text, comments, and operational guidance. Read
`references/technical-english.md`.

- Use one term for one thing. Do not cycle through synonyms.
- Prefer short common words and plain verbs.
- Put the actor before the action when the actor matters.
- Use concrete nouns, observable behavior, exact limits, and named sources.
- Give each paragraph one topic. Put conditions before the instruction they
  govern.
- Keep all facts, numbers, qualifiers, identifiers, and safety language.
- Treat sentence-length limits as warnings, not reasons to delete information.

### Strict controlled English

Use only when the user requests Simplified Technical English (STE), controlled
English, or a strict procedure or safety style.

Apply the stricter rules in `references/technical-english.md`, including simple
verb tenses, one instruction per sentence, sentence-length checks, articles,
and consistent terminology. Say that the result is STE-inspired unless it was
checked against the full ASD-STE100 specification by a qualified human.

## Core rules

- Let the intended meaning choose the words. Do not assemble the sentence from
  familiar phrases.
- Prefer concrete language over vague abstractions.
- Use the shortest familiar word that preserves the meaning and register.
- Cut any word, sentence, or section that adds no fact, reasoning, instruction,
  texture, or useful transition.
- Prefer active voice when it clarifies responsibility. Keep passive voice when
  the actor is unknown, irrelevant, or deliberately backgrounded.
- Use a verb for the action: "analyze the log," not "perform an analysis of the
  log."
- Repeat the correct noun when clarity needs it. Do not rename a dashboard as an
  interface, portal, and analytics hub.
- Name the source. Drop claims attributed only to "experts," "observers," or
  "reports."
- Keep claims proportional. Do not turn a local product or design choice into a
  historical turning point.
- Prefer one developed example over a string of names or analogies.
- Use formatting because the content needs it, not because every answer needs a
  template.

## Deslop rules

### Start and stop cleanly

Cut preambles such as "Here's the thing," "Let's break this down," and "It's
worth noting." Do not state how many points will follow unless the count itself
matters. Do not close with "In summary" or repeat the answer in different words.

### Avoid generated drama

Watch for repeated:

- negative reframes such as "not X, but Y";
- negative countdowns such as "Not X. Not Y. Just Z.";
- self-answered rhetorical questions;
- short standalone fragments used for emphasis;
- tricolons, anaphora, and quotable one-line slogans;
- false suspense, grand claims, and forced metaphors.

One instance can fit a human voice. Repetition is the tell.

### Remove model behavior from the prose

Do not narrate what the text is doing, what you intend to explain, or why you
are choosing a structure. Do not defend minor claims against objections nobody
raised. Do not summarize the same point at paragraph, section, and document
level.

### Use plain words

Prefer "use" to "utilize" or "leverage," "start" to "commence," and "is" to
"serves as." Avoid promotional adjectives and significance adverbs such as
"seamless," "robust," "quietly," "fundamentally," and "remarkably" unless the
word names a demonstrable property.

Domain terminology is correct when it is precise and the audience knows it.
Define necessary unfamiliar terms. Do not replace precise technical terms with
vague everyday words.

### Name the behavior

Words such as "safe," "stable," "clear," "complete," "portable," "minimal,"
and "lightweight" need evidence or a defined property. State the timeout, size,
compatibility rule, failure behavior, or other fact.

Reserve "boundary" for an edge or separation and "contract" for a formal API,
protocol, schema, or compatibility guarantee. Use "bounded" only with a stated
limit. Replace planning terminology with the feature, prerequisite, or version
that the reader needs.

### Keep formatting ordinary

- Use sentence case for headings.
- Avoid bold-first bullets as a default pattern.
- Avoid decorative Unicode and repeated em dashes.
- Use lists for lists. Do not disguise them as paragraphs beginning "First,"
  "Second," and "Third."
- Use semicolons and colons only when their grammatical function helps.
- Treat tables as structured data, not a place to compress prose.

## Editing method

1. Identify the audience, purpose, register, and selected mode.
2. Mark the facts, conditions, examples, and voice that must survive.
3. State each point once, before its support.
4. Cut preambles, duplication, filler, vague claims, and template endings.
5. Replace abstractions, nominalizations, and synonym cycling with concrete
   nouns and verbs.
6. Read for rhythm, grammar, tense, list parallelism, and clear references.
7. Check the relevant trope and technical-English references.
8. Return the revised text or the review format the user requested.

For a small edit, change the smallest useful span. For a rewrite, preserve every
fact and scope qualifier unless the user authorizes substantive changes.

## Quick check

- Does the first sentence answer instead of announce?
- Is any reasoning or planning leaking into the result?
- Does each claim appear once and before its evidence?
- Can any word or paragraph disappear without loss?
- Does each pronoun and floating word such as "same" or "existing" have a clear
  referent?
- Did the prose name actors, sources, limits, and behavior where needed?
- Did one trope or rhythm recur enough to become visible?
- Does the ending stop, or does it explain that it has ended?
- Did a style rule damage accuracy, safety, clarity, or the author's voice? If
  so, break the rule.

## Self-update

When a writing session reveals a reusable lesson, update the smallest owning
rule in this file or one reference. Replace stale guidance instead of adding a
history of corrections. Keep the main skill concise and put detailed catalogs
in one-level references.
