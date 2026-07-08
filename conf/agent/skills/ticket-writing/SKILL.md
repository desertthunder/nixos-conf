---
name: ticket-writing
description: Write implementation tickets, task breakdowns, milestone checklists, and agent-ready work items from a spec, plan, issue, or conversation. Use when the user asks for tickets, tasks, issues, milestones, a checklist, "to tickets", or wants to split an approved spec into buildable work after spec-writing.
---

# Ticket Writing

Use this skill after the plan or spec is clear enough to split into work. Produce
agent-ready tickets with explicit dependencies, acceptance criteria, and a clear
frontier of what can start first.

Read:

- `references/ticket-workflow.md` for slicing and dependency rules.
- `references/ticket-template.md` for local Markdown ticket formats.

## Default approach

1. Gather the source spec, issue, plan, or conversation context.
2. Inspect the repo when task shape depends on current architecture.
3. Draft work as vertical, verifiable slices rather than layer-only tasks.
4. Put enabling prefactors first when they make the implementation simpler.
5. Give every ticket its blockers. A ticket with no blockers is on the frontier.
6. Ask the user to approve granularity and dependencies before publishing or
   writing tracker issues.
7. Write local Markdown by default. Create or modify tracker issues only when the
   user explicitly asks.

## Ticket quality bar

Each ticket should include:

- a short outcome-oriented title;
- what to build from the user's perspective;
- blockers, or `None - can start immediately`;
- acceptance criteria;
- verification commands or manual checks when known;
- notes only when they prevent implementation drift.

Avoid file paths and code snippets unless they encode a settled decision more
precisely than prose can, such as a schema, state machine, or type shape.

## Milestone checklists

When the user asks for milestones instead of tickets, group tickets into ordered
milestones with an exit criterion for each milestone. Keep individual checklist
items verifiable and preserve blockers between milestones.

## Handoff

End with the frontier: the ticket or tickets that can be started immediately.
Recommend working one ticket per fresh context when the implementation will be
handled by an agent.
