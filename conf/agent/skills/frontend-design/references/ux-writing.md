# UX Writing

Write interface copy that helps the user decide and act.

## Name the action

Use specific verb-and-object labels:

- `Save changes` instead of `OK`;
- `Create account` instead of `Submit`;
- `Delete 5 items` instead of `Yes`;
- `Keep editing` when `Cancel` would be ambiguous.

Keep the interface's established terminology. Do not vary words for style when
they refer to the same object or action.

## Write useful errors

An error should say what happened and how to recover. Add the reason when it
helps the user fix the problem. Avoid blame, internal error codes without
context, humor, and vague messages.

Examples:

- `Enter an email address with an @ symbol.`
- `We couldn't save your changes. Check your connection and try again.`
- `You don't have access to this workspace. Ask an owner to invite you.`

Preserve the user's input and place the message where the problem occurred.

## Treat states as product moments

- Empty states should explain what belongs here and offer the next action.
- Loading copy should name the operation: `Saving your draft...`.
- Success copy should be brief and confirm the result.
- Destructive confirmations should name the object and irreversible
  consequence.

Do not add explanatory copy when the heading or control already says enough.

## Write for access and translation

- Give links standalone meaning.
- Give icon-only controls an accessible name.
- Describe the information an image conveys; use empty alt text for decoration.
- Keep full sentences in one translation string.
- Avoid concatenating fragments whose order may change.
- Allow text to expand by 30–40% and test buttons, navigation, tables,
  and errors with long strings.
- Keep numbers and variables easy for localization systems to reorder.

Match the product voice while adjusting tone to the moment. Errors need calm,
direct help; warnings need clarity; success can be warmer. Do not let brand
voice obscure the action or consequence.
