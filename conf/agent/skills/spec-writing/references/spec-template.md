# Spec template

Use this as a starting point. Delete sections that do not matter for the task.

```markdown
---
title: "{{ name }}"
status: "{{draft}} | {{ready}} | {{done}}"
---

## Objective

{{What we are building and why.}}

## User Stories and Use Cases

- {{User}} can {{action}} so that {{outcome}}.

## Success Criteria

- {{Observable result or acceptance criterion}}

## Current State

- {{Existing files, flows, APIs, or constraints.}}

## User Stories

1. As a {{actor}}, I want {{capability}}, so that {{benefit}}.

## Technical Plan

- Stack: <specific tools and versions>
- Data/API changes: <schemas, contracts, migrations>
- Implementation decisions: <settled choices, interfaces, schema/API contracts>

## Testing Plan

- Test boundary: <highest stable behavior boundary to verify through>
- Prior art: <similar tests or checks in this codebase>
- Commands: <exact commands, when known>

## Boundaries

- Always: <safe defaults>
- Ask first: <approval-required changes>
- Never: <hard stops>

## Deferred Milestones

- {{Essential follow-up work that should be planned later, not discarded.}}

## Verification

- {{Test or review step and expected result.}}

## Risks and open questions

- {{Risk, tradeoff, or question.}}
```

## Three-tier boundaries

- **Always:** Safe defaults the agent should do without asking, such as run the
  existing tests or follow existing patterns.
- **Ask first:** Risky or opinionated changes, such as adding dependencies,
  changing schemas, touching auth, changing public APIs, or broad refactors.
- **Never:** Hard stops, such as committing secrets, editing generated/vendor
  files, deleting data, or changing production config unless explicitly requested.

## Notes

- Keep implementation tickets out of the spec. Use `ticket-writing` when the
  user wants task breakdowns, dependency edges, or milestone checklists.
- Avoid brittle file paths unless they are essential current-state context. File
  paths age faster than architecture decisions.
