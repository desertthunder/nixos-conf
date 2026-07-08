# Grilling Method

Use this reference when a design interview has enough uncertainty to need
structure beyond the default `SKILL.md` rules.

## Question selection

Prefer questions that change implementation, sequencing, risk, or acceptance
criteria. Skip questions whose answers would only improve wording.

Good first questions usually target:

- the user or operator whose workflow must improve;
- the observable success condition;
- constraints that rule out common approaches;
- data ownership, permissions, privacy, migrations, or rollback;
- compatibility with existing architecture and tests;
- what must happen first for the next decision to be meaningful.

## Dependency order

Walk the plan as a decision tree:

1. Identify the root decision.
2. Resolve prerequisites before dependent details.
3. After each answer, update the working assumption.
4. Drop branches made irrelevant by earlier answers.

## Codebase facts

Look up facts before asking. Repository structure, existing APIs, test commands,
style conventions, and prior art are not user decisions.

Ask the user only when the answer is a product, business, risk, or taste
decision that cannot be inferred safely.

## Anti-patterns

- Do not ask a bulk list of questions.
- Do not continue past the default limit without naming what remains unresolved.
- Do not turn the interview into implementation.
- Do not relitigate decisions the user already confirmed unless new evidence
  changes the tradeoff.

## Sources

- Matt Pocock skills, `grill-me` and `grilling`:
  https://github.com/mattpocock/skills
