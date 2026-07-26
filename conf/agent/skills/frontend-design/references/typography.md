# Typography

Use type to establish hierarchy and rhythm before adding decoration.

## Choose a system

- Start from the product, audience, and surface mode. Do not choose a font from
  the category alone.
- One family with a useful range of weights is often enough for product UI.
  Add a second family only when it creates meaningful contrast.
- When pairing, contrast structure, proportion, or personality. Avoid two faces
  with similar structures and proportions.
- System fonts are appropriate when native feel, speed, or dense operation
  matters. Marketing and experience surfaces can justify more distinctive faces.
- Keep body text at least `1rem`. Use `rem` or `em` so browser preferences work.

Use a small scale with clear steps. Small differences create muddy hierarchy.
Product UI often wants a fixed ratio around 1.125–1.2. Display surfaces can use
larger contrast and bounded `clamp()` values; keep the maximum near 2.5 times the
minimum.

## Set readable rhythm

- Keep prose near 45–75 characters per line; 65–75ch is a useful default.
- Increase line-height for long measures and light-on-dark body text.
- Choose paragraph spacing or first-line indentation.
- Give headings more space above than below so spacing communicates grouping.
- Use `text-wrap: balance` for short headings and `text-wrap: pretty` for prose.
- Add modest tracking to short all-caps labels. Do not use all-caps as a default
  section grammar.

## Load fonts without layout shift

- Use `font-display: swap` when the branded face should appear after load.
- Use `font-display: optional` when avoiding a late swap matters more.
- Preload only the critical above-the-fold weight.
- Match fallback metrics with `size-adjust`, `ascent-override`,
  `descent-override`, and `line-gap-override` when shifts are visible.
- Prefer a variable font when the design uses three or more weights.
- Use `font-optical-sizing: auto` when the font supports it.

## Use OpenType features

```css
.live-number,
.data-column {
  font-variant-numeric: tabular-nums;
}

code {
  font-variant-ligatures: none;
}
```

Use tabular figures for changing counters, prices, timers, scores, and aligned
numeric columns. Check the actual numeral shapes in the chosen font.

On macOS, `-webkit-font-smoothing: antialiased` can make text appear lighter.
Apply it once at the root only when it improves the chosen face; it is an
aesthetic choice.

## Check the result

- Test real copy at every relevant width and at 200% zoom.
- Check fallback and loaded-font states.
- Verify hierarchy without relying on color alone.
- Avoid decorative faces for body text, more than two or three families, and
  text that only fits because overflow is hidden.
