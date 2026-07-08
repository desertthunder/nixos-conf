---
name: grill-me
description: Stress-test a plan, design, architecture, or product decision through a bounded one-question-at-a-time interview. Use when the user says "grill me", asks to be challenged, wants a plan pressure-tested, or needs ambiguities resolved before writing a spec or implementation tickets.
---

# Grill Me

Use this skill to sharpen a plan before it becomes a spec, ticket list, or code.
Ask one question at a time, give your recommended answer, and wait for the user
before continuing.

Read `references/grilling-method.md` when the session needs a deeper interview
structure.

## Operating rules

1. Start by naming the decision area you are testing and the current assumption.
2. Ask the highest-leverage unresolved question first.
3. Explore facts from the codebase or source material instead of asking the user.
4. Treat decisions as the user's to make. Provide a recommendation, but wait for
   confirmation.
5. Track a short decision log as the interview progresses.
6. Stop before implementation unless the user explicitly asks to move on.

## Limits

Keep the session bounded by default:

- Ask at most 8 substantive questions in one pass.
- Stop earlier when no remaining answer would materially change the plan.
- After 3 unanswered or deferred questions, summarize the unresolved risks and
  ask whether to continue, write a spec, or pause.
- If the user asks for more, start a new bounded pass with a narrower focus.

## Closing

End with:

- settled decisions;
- remaining open questions, if any;
- risks or tradeoffs the user accepted;
- the recommended next step, usually `spec-writing` or `ticket-writing`.
