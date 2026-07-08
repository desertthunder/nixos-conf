# Spec workflow

## Planning workflow

When drafting a spec for an agent:

1. Inspect the repo or source material before inventing structure.
2. Identify the smallest useful deliverable.
3. If the user asks to turn an existing conversation into a spec, synthesize what
   is known instead of reopening discovery.
4. If there are several plausible designs, present options with tradeoffs before
   choosing one.
5. Identify the highest stable test boundary for the feature. Prefer existing
   behavior boundaries over new ones.
6. Check architecture-shaping test boundaries with the user before finalizing.
7. Write the spec in Markdown with stable headings so sections can be pasted into
   future agent prompts.
8. Break large work into phases: specify, ticket, implement, verify.
9. For each phase, define what evidence proves it is complete.

For production code, be precise and directive. Function signatures, exact file
paths, examples, and failing test cases usually beat prose.

## Context rules

- Include current docs or examples for libraries that may be newer than a model's
  training cutoff.
- Keep context relevant. Summarize or link large material instead of pasting all
  of it into every prompt.
- For large specs, add a short table of contents and per-section summaries.
- Start a fresh agent session when the current conversation becomes noisy, and
  seed it with the approved spec plus only the relevant current files.

## Handoff rules

- A spec captures intent, settled decisions, verification strategy, and important
  constraints.
- Tickets capture sequencing, dependencies, and individual implementation work.
- Move to `ticket-writing` when the user asks for tasks, tickets, issues,
  milestones, or a build checklist.
