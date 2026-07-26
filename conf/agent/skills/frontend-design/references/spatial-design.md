# Spatial Design

Use spacing, alignment, scale, and composition to group content before reaching
for cards or borders.

## Establish rhythm

Use a small 4px-based scale such as 4, 8, 12, 16, 24, 32, 48, 64, and 96px.
Name tokens by relationship, such as `--space-sm`, and use `gap` for siblings.
Keep related items tight and give unrelated groups more space.

Create hierarchy across two or more dimensions: size, weight, color, position,
and surrounding space. Use the squint test: the primary element, secondary
element, and major groups should remain obvious when details blur.

## Compose across widths

- Use grid for page composition and flexbox for one-dimensional groups.
- Use `repeat(auto-fit, minmax(...))` only when equal flexible columns match the
  content.
- Use named grid areas when the reading order changes across breakpoints.
- Use container queries for reusable components and viewport queries for page
  layout.
- Allow asymmetry, overlap, and negative space when they reinforce
  the direction and preserve reading order.

## Use surfaces

Reserve cards for distinct, comparable, or actionable content. Group content
inside a card with spacing, type, and dividers.

Use borders for separation and form boundaries. Use restrained shadows for
elevation. Avoid combining a visible border and a broad shadow unless both have
separate jobs.

For nested rounded surfaces:

```text
outer radius = inner radius + inset
```

Apply this when surfaces sit close together. With large separation, treat them
as independent surfaces. Keep pills for compact controls, tags, and statuses.

## Adjust optical alignment

Geometric centering can look wrong:

- shift play icons toward the point;
- adjust asymmetric icons in the SVG when possible;
- reduce padding on the icon side of a text-and-icon button;
- align display text by its visible letterforms when the font's side bearings
  create an obvious indent.

Make these corrections by eye after the underlying geometry is sound.

## Keep depth coherent

Define semantic elevation and z-index levels: content, sticky UI, dropdown,
backdrop, modal, toast, and tooltip. Avoid arbitrary four-digit z-index values.

Add a subtle inset outline to images when their edges disappear into nearby
surfaces:

```css
.framed-image {
  outline: 1px solid color-mix(in oklch, currentColor 10%, transparent);
  outline-offset: -1px;
}
```

Check computed spacing, clipping, and alignment in the rendered interface rather
than trusting token names.
