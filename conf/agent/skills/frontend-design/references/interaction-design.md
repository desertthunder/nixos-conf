# Interaction Design

Design behavior and states with the component.

## Cover the state model

Handle every state that applies: default, hover, focus, active, disabled,
loading, error, empty, and success. Hover and focus are distinct. Keep every
action available without hover.

Use `:focus-visible` and provide a consistent indicator with at least 3:1
contrast. Do not remove an outline without an equivalent replacement.

Interactive targets should be at least 44 by 44 CSS pixels when practical.
Extend a small visible control with padding or a pseudo-element. Keep expanded
hit areas from overlapping.

## Build clear forms

- Keep visible labels and reserve placeholders for examples.
- Validate on blur or submission rather than on every keystroke, except when
  continuous feedback is the feature.
- Put errors beside or below the field and connect them with
  `aria-describedby`.
- Preserve entered values after errors.
- Use native controls where they provide the correct semantics and keyboard
  behavior.

## Choose overlays

Use inline disclosure before a modal. Use native `<dialog>` for protected modal
focus and the Popover API for non-modal menus and tooltips when browser support
fits the project.

An overlay with `position: absolute` may clip inside an overflow or transformed
ancestor. Escape through the top layer, a portal, or fixed positioning. Check
viewport edges and flip or resize as needed.

Use roving tabindex and arrow-key behavior for tabs, menus, radio groups, and
similar composite widgets. Provide skip links for repeated navigation.

## Make waiting and failure useful

- Use skeletons when the content shape is known.
- Use precise progress text for longer operations.
- Use optimistic updates only for low-risk, reversible actions.
- Keep loading indicators from changing the control's layout.
- Make empty states explain the next useful action.

Prefer undo over confirmation for reversible deletion. Confirm irreversible,
high-cost, or broad actions and state the consequence.

## Polish feedback

Use small press feedback, optical icon alignment, and state transitions when
they clarify response. Keep disabled controls legible. Test keyboard, pointer,
touch, rapid repeated input, Escape, outside click, and focus restoration.
