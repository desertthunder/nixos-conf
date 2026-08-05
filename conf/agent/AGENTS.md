# Agents

Git is read-only.

Prefer simple, maintainable solutions. Correctness comes first, but thoroughness
does not mean expanding the task. Trace the relevant flow, fix the root cause,
and stop when the requested deliverable is complete and verified.

## Scope and token use

- Treat one conversation as one deliverable. Do not absorb unrelated backlog,
  cleanup, research, or polish without an explicit request.
- Do not spawn subagents unless the user explicitly asks for them.
- Keep tool output narrow. Search targeted paths, read only relevant ranges, and
  cap logs or test output. Do not dump whole files, generated trees, dependency
  listings, or session transcripts when a smaller query answers the question.
- Do not rerun unchanged checks or poll completed work. Retry only after a
  relevant change or when new evidence justifies it.
- Use the smallest proportionate verification. Run focused checks before broad
  suites, and stop after the result is established.
- Finish completed work with a concise handoff. If the user introduces a new
  deliverable after a long or compacted thread, recommend a fresh conversation
  and provide the short context it needs.
- Do not create status or handoff files by default. Create one only when the
  user asks, work must continue in another session, or meaningful work remains
  incomplete and needs durable context.

## Working with Owais

- Steering is expected. Treat it as a correction or refinement of the active
  deliverable unless it clearly introduces a separate deliverable.
- Apply a correction without repeating exploration or checks that it does not
  invalidate. Queue a separate deliverable after the current bounded slice
  instead of restarting the whole workflow.
- Numbered requests are required scope. Resolve dependencies between them, then
  complete them in the smallest coherent order without adding adjacent backlog.
- Visual feedback is usually precise. Make the smallest localized UI change and
  verify the affected state instead of reopening the whole design.
- User-facing copy should describe the product in the reader's language. Keep
  implementation details, internal planning labels, and test vocabulary out of
  it unless the audience needs them.
- Question fixtures, helpers, abstractions, and documentation that duplicate
  behavior already covered elsewhere. Keep them only when they protect a real
  boundary or failure mode.

## Implementation

Before writing code, check whether the work is necessary, already exists in the
codebase, or is covered by the standard library, platform, or an installed
dependency. Then write the minimum clear implementation that handles the real
use cases.

Reuse established helpers and patterns. Inline helpers with one call site. Avoid
inline or function-scoped imports.

A bug report names a symptom. Inspect callers and fix the shared cause when one
exists instead of patching only the reported path.

## Documentation

Use the writing/deslop skill when updating documentation. Write for the human
reader, keep prose direct, and avoid internal implementation detail unless the
audience needs it.

If the user must perform follow-up steps, print a prominent
"YOUR ATTENTION IS REQUIRED" banner with fitting emoji.
