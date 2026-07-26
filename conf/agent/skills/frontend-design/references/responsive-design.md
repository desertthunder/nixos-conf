# Responsive Design

Design each width as a composition with the same content and intent.

## Let content set breakpoints

Start with the narrow layout, widen until the content or relationship breaks,
then add a `min-width` query there. Use a few meaningful breakpoints rather than
a device catalog. Keep source order logical even when the visual arrangement
changes.

Use fluid values where continuity helps and discrete changes where structure
changes:

- `clamp()` for bounded display type, gaps, and page padding;
- viewport queries for page composition;
- container queries for reusable components;
- explicit breakpoints for navigation, tables, and major layout changes.

## Detect capabilities

Screen width does not identify the input device. Use `hover` and `pointer`
queries to tune hit areas and hover effects. Keep required behavior available
without hover.

```css
@media (pointer: coarse) {
  .control {
    min-block-size: 44px;
    min-inline-size: 44px;
  }
}

@media (hover: hover) {
  .control:hover {
    /* optional enhancement */
  }
}
```

## Handle device boundaries

Use `viewport-fit=cover` when the design reaches screen edges, then account for
`env(safe-area-inset-*)`. Test landscape, browser chrome, and on-screen
keyboards. Avoid fixed elements that cover focused form fields.

## Deliver responsive media

Use `srcset` and `sizes` for resolution selection. Use `<picture>` when mobile
needs a different crop or composition. Set intrinsic dimensions or `aspect-ratio`
to prevent layout shift. Keep meaningful alt text aligned with the final crop.

## Adapt patterns

- Collapse or reorganize navigation without hiding critical destinations.
- Let dense tables scroll, reduce columns, or present selected details. Avoid
  converting every row into a verbose card.
- Use progressive disclosure when it preserves comprehension.
- Keep primary actions reachable and stable.
- Check long translations and real content.

Test narrow and wide desktop, a small phone, a large phone, and real devices
when the project permits. DevTools does not reproduce touch, memory pressure,
font rendering, browser chrome, or keyboard behavior.
