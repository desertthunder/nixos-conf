---
name: spec-writing
description: >
  Write, review, and iterate software specs for AI coding agents. 
  Use when the user asks for a spec, PRD, SRS, implementation plan, acceptance
  criteria, agent instructions, "to spec", or wants to turn an idea, plan, or
  settled conversation into code-ready requirements. For task lists, tickets,
  milestone checklists, or splitting a spec into implementation work, use
  ticket-writing instead.
---

# Spec Writing

Use this skill to turn a rough idea, repo finding, or settled conversation into
a clear, code-ready spec for a human or AI coding agent. The goal is enough
structure to prevent drift without burying the agent in irrelevant context.

When the user asks to convert the current conversation into a spec, synthesize
what is already known. Do not reopen discovery unless a missing decision would
materially change the implementation.

## References

Read these when the task needs more detail:

- `references/spec-template.md`: reusable Markdown spec template and boundary
  format.
- `references/spec-workflow.md`: planning workflow and context rules.
- `references/review-checklist.md`: pre-handoff and verification checks.

## Default approach

1. Start with the user's goal, users, and definition of success.
2. Inspect the repo or source material before inventing structure.
3. Ask only missing questions that would change the implementation.
4. Draft the smallest useful spec first, then expand details where ambiguity
   remains.
5. Separate product intent from technical decisions and task execution.
6. Keep each agent task focused. Do not turn a large project into one giant
   prompt.
7. Include tests, commands, boundaries, and review checkpoints.
8. Treat the spec as a living artifact. Update it when implementation teaches
   you something.

## What a good spec includes

For most coding tasks, cover these sections:

- **Objective:** What are we building and why?
- **Users / use cases:** Who needs this, and what must they be able to do?
- **Success criteria:** Observable outcomes and acceptance criteria.
- **Current state:** Existing files, APIs, flows, constraints, and known issues.
- **Tech stack:** Specific frameworks, versions, libraries, and platform rules.
- **Commands:** Exact build, test, lint, typecheck, and dev commands.
- **Testing plan:** What tests to add or run, and what must pass.
- **Test boundary:** The highest stable behavior boundary the work should be
  verified through, preferring existing boundaries.
- **Project structure:** Where code, tests, docs, migrations, assets, or config go.
- **Code style:** Concrete conventions or one short example of preferred style.
- **Boundaries:** What the agent may do freely, must ask before doing, and must
  never do.
- **Implementation plan:** Ordered steps small enough to verify one at a time.
- **Deferred milestones:** Essential work that belongs later, with the reason it is sequenced later.
- **Risks / open questions:** Unknowns, tradeoffs, security issues, migrations,
  data loss, performance, accessibility, or compatibility concerns.

Use only sections that matter for the request. For a small function, a signature,
behavior list, edge cases, and tests may be enough.

## Scope rules

- Do not use a `Non-goals` section by default.
  Essential feature work should be planned as milestones, deferred milestones,
  dependencies, or explicit sequencing rather than trimmed out of the spec.
- Only describe something as out of scope when it is truly not part of the product
  direction, not merely too large for the first implementation pass.

## Planning rules

- Identify the smallest useful deliverable.
- Present options with tradeoffs when several designs are plausible.
- Check the proposed test boundary with the user when it affects architecture
  or task shape.
- Use stable Markdown headings so sections can be pasted into future prompts.
- Break large work into phases: specify, ticket, implement, verify.
- Define what evidence proves each phase complete.

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

## Artifact size

- Target at most roughly 600 lines for one spec file. This is a focus boundary,
  not permission to omit requirements, verification, risks, or settled
  decisions.
- Remove repetition and tighten prose before splitting the artifact.
- If a complete spec would still exceed the target, keep the core product and
  architecture contract in the main spec and move a cohesive supporting body,
  such as a protocol schema, fixture catalogue, or migration appendix, into a
  clearly linked companion file.
- Do not create a separate decision log when settled decisions can be stated
  once in the relevant spec sections.

## Verification rules

A spec is incomplete until it says how the result will be checked. Include exact
commands, expected outcomes, edge cases, regression checks, and human review
points where relevant.

Do not trust generated code without review. The human remains responsible for
correctness.

## Handoff

When the user wants the spec split into implementation tickets, stop using this
skill and invoke `ticket-writing`. The ticket step should preserve the spec's
intent and slice the work into verifiable tasks with explicit dependencies.

## Self-update

This is a living skill. When a spec-writing session reveals a reusable lesson,
update this `SKILL.md` or its references with the smallest rule that would
prevent the same issue next time.

Update when:

- the user corrects a missing or harmful spec pattern, such as using non-goals to hide essential deferred work;
- a generated spec causes implementation drift;
- a verification step was missing or too vague;
- a better template, boundary, or review question proves useful repeatedly;
- the source articles change and the user asks for a refresh.

When updating, preserve the simple structure, keep rules concrete, and avoid
adding one-off project details.

## Sources

- Addy Osmani, "How to write a good spec for AI agents":
  https://addyosmani.com/blog/good-spec/
- Simon Willison, "Here's how I use LLMs to help me write code":
  https://simonwillison.net/2025/Mar/11/using-llms-for-code/
- Matt Pocock skills, `to-spec` and `to-tickets`:
  https://github.com/mattpocock/skills
