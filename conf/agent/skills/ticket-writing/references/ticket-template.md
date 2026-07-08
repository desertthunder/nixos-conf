# Ticket Templates

## Local ticket file

```markdown
# Tickets: <short name>

<One-line summary of what these tickets build. Reference the source spec if one
exists.>

Work the frontier: any ticket whose blockers are complete.

## <Ticket title>

**What to build:** <End-to-end behavior this ticket makes work from the user's
perspective.>

**Blocked by:** None - can start immediately

**Acceptance criteria:**

- [ ] <Observable criterion>
- [ ] <Observable criterion>

**Verification:**

- <Command or manual check, if known>

## <Ticket title>

**What to build:** <End-to-end behavior this ticket makes work.>

**Blocked by:** <Ticket title>

**Acceptance criteria:**

- [ ] <Observable criterion>

**Verification:**

- <Command or manual check, if known>
```

## Tracker issue

```markdown
## Parent

<Reference to the source spec or parent issue, if any.>

## What to build

<End-to-end behavior this ticket makes work from the user's perspective.>

## Acceptance criteria

- [ ] <Observable criterion>
- [ ] <Observable criterion>

## Verification

- <Command or manual check, if known>

## Blocked by

- None - can start immediately
```

## Milestone checklist

```markdown
# Milestones: <short name>

## Milestone 1: <name>

**Exit criterion:** <Observable milestone completion signal.>

- [ ] <Ticket or task title> - blocked by: <none or blockers>
- [ ] <Ticket or task title> - blocked by: <blocker>

## Milestone 2: <name>

**Exit criterion:** <Observable milestone completion signal.>

- [ ] <Ticket or task title> - blocked by: <blocker>
```
