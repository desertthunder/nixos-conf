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

## Technical Plan

- Stack: <specific tools and versions>
- Files to touch: <paths>
- Data/API changes: <schemas, contracts, migrations>

## Boundaries

- Always: <safe defaults>
- Ask first: <approval-required changes>
- Never: <hard stops>

## Deferred

- {{Essential follow-up work that should be planned later, not discarded.}}

## Implementation tasks

1. {{Small verifiable step}}
2. {{Small verifiable step}}
3. {{Small verifiable step}}

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
