# Spec review checklist

Before handing a spec to an agent, check:

- Can a new contributor tell what success looks like?
- Are stack, files, commands, and tests specific?
- Are boundaries explicit?
- Is the task sliced into verifiable steps?
- Are unresolved decisions marked as questions instead of hidden assumptions?
- Is the spec short enough to keep the agent focused?

## Verification checklist

A spec is incomplete until it says how the result will be checked. Include, where
relevant:

- exact commands to run;
- unit, integration, e2e, or manual test cases;
- expected output or UI behavior;
- edge cases and failure modes;
- regression checks for the bug or requirement;
- human review points for subjective UX, copy, or architecture calls.

Do not trust generated code without review. The human remains responsible for
correctness.
