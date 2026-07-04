# Spec template

Use this as a starting point. Delete sections that do not matter for the task.

```markdown
# Spec: <name>

## Objective
<What we are building and why.>

## Users and use cases
- <User> can <action> so that <outcome>.

## Success criteria
- <Observable result or acceptance criterion.>

## Non-goals
- <Thing we are not doing now.>

## Current state
- <Existing files, flows, APIs, or constraints.>

## Technical plan
- Stack: <specific tools and versions>
- Files to touch: <paths>
- Data/API changes: <schemas, contracts, migrations>

## Commands
- Build: `<command>`
- Test: `<command>`
- Lint/typecheck: `<command>`

## Boundaries
- Always: <safe defaults>
- Ask first: <approval-required changes>
- Never: <hard stops>

## Implementation tasks
1. <Small verifiable step>
2. <Small verifiable step>
3. <Small verifiable step>

## Verification
- <Test or review step and expected result.>

## Risks and open questions
- <Risk, tradeoff, or question.>
```

## Three-tier boundaries

- **Always:** Safe defaults the agent should do without asking, such as run the
  existing tests or follow existing patterns.
- **Ask first:** Risky or opinionated changes, such as adding dependencies,
  changing schemas, touching auth, changing public APIs, or broad refactors.
- **Never:** Hard stops, such as committing secrets, editing generated/vendor
  files, deleting data, or changing production config unless explicitly requested.
